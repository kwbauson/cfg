{ path, pkgs }:
with builtins; with pkgs; with mylib;
rec {
  ifFiles = fs: optional (all (f: pathExists (file f)) (splitString " " fs));
  file = f: path + ("/" + f);

  wrapScriptWithPackages = src: env: rec {
    text = readFile src;
    name = baseNameOf src;
    lines = splitString "\n" text;
    pkgsMark = " with-packages ";
    pkgsLines = map
      (x: splitString pkgsMark x)
      (filter (hasInfix pkgsMark) lines);
    pkgsNames = flatten (map (x: splitString " " (elemAt x 1)) pkgsLines);
    buildInputs = map (x: getAttrFromPath (splitString "." x) pkgs) pkgsNames ++ build-paths;
    selfHash = hashString "sha256" selfpkgs.outPath;
    makeScriptText = replaceStrings
      [ "CFG_STORE_PATH" "NIX_LOCAL_ENV_HASH" ]
      [ selfpkgs.outPath selfHash ];
    isBash = hasSuffix "bash" (head lines);
    script = writeScript "${name}-unwrapped" (makeScriptText text);
    scriptTail = makeScriptText (concatStringsSep "\n" (tail lines));
    out = writeShellScriptBin name ''
      export ${pathAdd buildInputs}
      ${if isBash then scriptTail else ''exec ${script} "$@"''}
    '';
  }.out;

  localfile = file "local.nix";
  local-bin-paths =
    ifFiles "bin"
      (map (x: wrapScriptWithPackages (file "bin/${x}") { }) (attrNames (readDir (file "bin"))));
  local-nix = rec {
    imported = import localfile;
    result = if isFunction imported then imported pkgs else imported;
    out = if pathExists localfile then result else null;
  }.out;
  local-nix-paths = ifFiles "local.nix" [ local-nix.paths or local-nix ];
  node-modules-paths =
    ifFiles "package.json package-lock.json node-packages.nix"
      rec {
        originalArgs = (callPackage (file "node-packages.nix") { inherit nodeEnv; }).args;
        args = originalArgs // {
          src = buildDir (map file [ "package.json" "package-lock.json" ]);
          dontNpmInstall = true;
        };
        node_modules = override (nodeEnv.buildNodeDependencies args) { name = "node_modules"; };
        out = lowPrio node_modules;
      }.out;

  yarn-paths =
    optional
      (!pathExists (file ".disable-nle-yarn"))
      (
        ifFiles "package.json yarn.lock npm-package.nix npm-deps.nix"
          rec {
            inherit (yarn2nix.nixLib) callTemplate buildNodeDeps linkNodeDeps;
            built = callTemplate (file "npm-package.nix") (buildNodeDeps (callPackage (file "npm-deps.nix") { }));
            link = linkNodeDeps { name = "yarn"; dependencies = built.nodeBuildInputs; };
            out =
              runCommand "node_modules"
                { } ''
                mkdir $out
                [[ -e ${link}/.bin ]] && ln -s ${link}/.bin $out/bin
                ln -s ${link} $out/node_modules
              '';
          }.out
      );
  bundler-paths =
    ifFiles "Gemfile Gemfile.lock gemset.nix"
      rec {
        locktext = readFile (file "Gemfile.lock");
        latestBundlerMark = "BUNDLED WITH\n   ${bundler.version}\n";
        hasLatestBundler = hasSuffix latestBundlerMark locktext;
        namespace = if hasLatestBundler then { } else nixpkgs-bundler1;
        env = with namespace; bundlerEnv {
          name = "bundler-env";
          gemfile = file "Gemfile";
          lockfile = file "Gemfile.lock";
          gemset = file "gemset.nix";
          ignoreCollisions = true;
          allowSubstitutes = true;
          groups = [ "default" "development" "test" ];
          gemConfig = defaultGemConfig // {
            zipruby = _: { buildInputs = [ zlib ]; };
            grpc = attrs: defaultGemConfig.grpc attrs // {
              AROPTS = "-r";
            };
            plivo = _: { buildInputs = [ rake ]; };
          };
        };
        paths = [ env.wrappedRuby (hiPrio env) bundix ];
      }.paths;
  python-paths = with rec {
    hasRequirements = pathExists (file "requirements.txt");
    hasRequirementsDev = pathExists (file "requirements.dev.txt");
  };
    optional
      (hasRequirements || hasRequirementsDev)
      (
        override
          (mach-nix.mkPython {
            requirements = ''
              ${optionalString hasRequirements (excludeLines (hasPrefix "itomate") (readFile (file "requirements.txt")))}
              ${optionalString hasRequirementsDev (readFile (file "requirements.dev.txt"))}
            '';
            _.black.buildInputs = [ ];
            _.${attrIf isDarwin "lazy-object-proxy"}.buildInputs = [ ];
          }) { name = "python-env"; }
      );

  build-paths = flatten [
    local-nix-paths
    bundler-paths
    node-modules-paths
    yarn-paths
    python-paths
  ];

  paths = flatten [ (map (setPrio 1) (flatten local-bin-paths)) build-paths ];

  packages = listToAttrs (map (x: { name = x.name; value = x; }) paths);

  out = (buildEnv { name = "local-env"; inherit paths; }) // {
    pkgs = packages;
    nle = { path }: import ./nix-local-env.nix { inherit path pkgs; };
    pinned =
      if local-nix ? rev && local-nix ? sha256
      then fetchTarball {
        url = "https://github.com/kwbauson/cfg/archive/${local-nix.rev}.tar.gz";
        inherit (local-nix) sha256;
      }
      else out.nle { inherit path; };
  };
}.out
