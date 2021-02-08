{ path, pkgs }:
with builtins; with pkgs; with mylib;
rec {
  hasFiles = fs: all (f: pathExists (file f)) (splitString " " fs);
  ifFiles = fs: optional (hasFiles fs);
  ifFilesAndNot = fs: fs2: optional (hasFiles fs && !hasFiles fs2);
  file = f: path + ("/" + f);

  nle-conf = fixSelfWith (import ./nle.nix) { source = path; inherit pkgs; };

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
    ifFilesAndNot "package.json package-lock.json node-packages.nix" "yarn.nix"
      (lowPrio nle-conf.npm.out);

  yarn-paths =
    ifFilesAndNot "package.json yarn.lock yarn.nix" ".disable-nle-yarn"
      rec {
        yarn2nix-moretea =
          callPackage
            "${pkgs.path}/pkgs/development/tools/yarn2nix-moretea/yarn2nix" {
            nodejs = nodejs_latest;
          };
        package = with yarn2nix-moretea; mkYarnModules rec {
          name = pname;
          pname = "yarn-modules";
          version = "";
          packageJSON = file "package.json";
          yarnLock = file "yarn.lock";
          yarnNix = file "yarn.nix";
        };
        out =
          runCommand "yarn-env"
            { } ''
            mkdir $out
            [[ -e ${package}/node_modules/.bin ]] && ln -s ${package}/node_modules/.bin $out/bin
            ln -s ${package}/node_modules $out/node_modules
          '';
      }.out;
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
          groups = null;
          gemConfig = defaultGemConfig // {
            zipruby = _: { buildInputs = [ zlib ]; };
            grpc = attrs: defaultGemConfig.grpc attrs // {
              AROPTS = "-r";
            };
            plivo = _: { nativeBuildInputs = [ rake ]; };
          };
        };
        paths = [ env.wrappedRuby (hiPrio env) ];
      }.paths;
  mach-nix-paths = with rec {
    hasRequirements = pathExists (file "requirements.txt");
    hasRequirementsDev = pathExists (file "requirements.dev.txt");
  };
    optional
      ((hasRequirements || hasRequirementsDev) && !hasFiles "poetry.lock")
      (override nle-conf.pip.out { name = "pip-env"; });

  poetry-paths =
    ifFiles nle-conf.poetry.files (override nle-conf.poetry.out { name = "poetry-env"; });

  build-paths = flatten [
    local-nix-paths
    bundler-paths
    node-modules-paths
    yarn-paths
    mach-nix-paths
    poetry-paths
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
