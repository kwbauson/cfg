{ path, pkgs ? import ./. }:
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
    selfHash = hashString "sha256" ''
      ${readFile ./nix-local-env.nix}
      ${readFile ./bin/nix-local-env}
      ${cfg.inputs.nixpkgs.outPath}
      ${cfg.inputs.mach-nix.outPath}
    '';
    makeScriptText = replaceStrings
      [ "CFG_STORE_PATH" "NIX_LOCAL_ENV_HASH" ]
      [ (toString cfg.outPath) selfHash ];
    isBash = hasSuffix "bash" (head lines);
    script = writeScript "${name}-unwrapped" (makeScriptText text);
    scriptTail = makeScriptText (concatStringsSep "\n" (tail lines));
    out = writeShellScriptBin name ''
      export ${pathAdd buildInputs}
      ${if isBash then scriptTail else ''exec ${script} "$@"''}
    '';
  }.out;

  local-bin-paths =
    ifFiles "bin"
      (map (x: wrapScriptWithPackages (file "bin/${x}") { }) (attrNames (readDir (file "bin"))));
  local-nix-paths =
    ifFiles "local.nix"
      rec {
        imported = import (file "local.nix");
        out = if isFunction imported then imported pkgs else imported;
        paths = flatten [ out ];
      }.paths;
  node-modules-paths =
    ifFiles "package.json package-lock.json node-packages.nix"
      rec {
        originalArgs = (callPackage (file "node-packages.nix") { inherit nodeEnv; }).args;
        args = originalArgs // {
          src = buildDir (map file [ "package.json" "package-lock.json" ]);
          dontNpmInstall = true;
        };
        node_modules = (nodeEnv.buildNodeDependencies args).overrideAttrs (_: { name = "node_modules"; });
        out = lowPrio node_modules;
      }.out;
  bundler-paths =
    ifFiles "Gemfile Gemfile.lock gemset.nix"
      rec {
        locktext = readFile (file "Gemfile.lock");
        latestBundlerMark = "BUNDLED WITH\n   ${bundler.version}\n";
        hasLatestBundler = hasSuffix latestBundlerMark locktext;
        namespace = if hasLatestBundler then { } else nixpkgs-bundler1;
        env = with namespace; let
          addBuildInputs = (n: extraInputs: attrs: gemConfigOf n //
            (
              if isList extraInputs
              then { buildInputs = attrs.buildInputs or [ ] ++ extraInputs; }
              else extraInputs (gemConfigOf n)
            ));
          gemConfigOf = n: (defaultGemConfig.${n} or (_: { })) { };
        in
        bundlerEnv {
          name = "bundler-env";
          gemfile = file "Gemfile";
          lockfile = file "Gemfile.lock";
          gemset = file "gemset.nix";
          ignoreCollisions = true;
          allowSubstitutes = true;
          gemConfig = defaultGemConfig // mapAttrs addBuildInputs {
            zipruby = [ zlib ];
            grpc = attrs: { AROPTS = "-r"; };
            plivo = [ rake ];
          } // {
            ${attrIf isDarwin "grpc"} = attrs: { buildInputs = [ pkgconfig openssl darwin.cctools ]; };
          }
          ;
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
        mach-nix.mkPython {
          requirements = ''
            ${optionalString hasRequirements (excludeLines (hasPrefix "itomate") (readFile (file "requirements.txt")))}
            ${optionalString hasRequirementsDev (readFile (file "requirements.dev.txt"))}
          '';
          _.black.buildInputs = [ ];
          _.${attrIf isDarwin "lazy-object-proxy"}.buildInputs = [ ];
        }
      );

  build-paths = flatten [
    local-nix-paths
    bundler-paths
    node-modules-paths
    python-paths
  ];

  paths = flatten [ (map (setPrio 1) (flatten local-bin-paths)) build-paths ];

  packages = listToAttrs (map (x: { name = x.name; value = x; }) paths);

  out = (buildEnv { name = "local-env"; inherit paths; }) // {
    pkgs = packages;
    nle = import ./nix-local-env.nix;
  };
}.out
