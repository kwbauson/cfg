{ path, pkgs ? import ./. }:
with builtins; with pkgs; with mylib;
rec {
  ifFiles = fs: optional (all (f: pathExists (file f)) (splitString " " fs));
  file = f: path + ("/" + f);

  wrapScriptWithPackages = src: env: rec {
    text = readFile src;
    name = baseNameOf src;
    pkgsMark = " with-packages ";
    pkgsLines = map
      (x: splitString pkgsMark x)
      (filter (hasInfix pkgsMark) (splitString "\n" text));
    pkgsNames = flatten (map (x: splitString " " (elemAt x 1)) pkgsLines);
    buildInputs = build-paths ++ map (x: getAttrFromPath (splitString "." x) pkgs) pkgsNames;
    pathLines = concatStringsSep "\n" (map (x: "export PATH=${x}/bin:$PATH") buildInputs);
    selfHash = hashString "sha256" ''
      ${readFile ./nix-local-env.nix}
      ${readFile ./bin/nix-local-env}
    '';
    wrapper = stdenv.mkDerivation {
      name = "${name}-wrapper";
      inherit src buildInputs;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/${name}
        substituteInPlace $out/bin/${name} \
          --replace CFG_STORE_PATH ${cfg.outPath} \
          --replace NIX_LOCAL_ENV_HASH ${selfHash}
      '';
    };
    out = writeShellScriptBin name ''
      ${pathLines}
      exec ${wrapper}/bin/${name} "$@"
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
    ifFiles "package.json package-lock.json"
      (import ./node-env.nix { inherit path pkgs; });
  bundler-paths =
    ifFiles "Gemfile Gemfile.lock gemset.nix"
      rec {
        addBuildInputs = (n: extraInputs: attrs: gemConfigOf n //
          (
            if isList extraInputs
            then { buildInputs = attrs.buildInputs or [ ] ++ extraInputs; }
            else extraInputs (gemConfigOf n)
          ));
        gemConfigOf = n: (defaultGemConfig.${n} or (_: { })) { };
        env = with nixpkgs-bundler1; bundlerEnv {
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

  out = (buildEnv { name = "local-env"; inherit paths; }) // { inherit packages; };
}.out
