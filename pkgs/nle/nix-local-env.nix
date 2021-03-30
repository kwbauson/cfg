{ path, pkgs }:
with builtins; with pkgs; with mylib;
rec {
  hasFiles = fs: words fs != [ ] && all (f: pathExists (file f)) (words fs);
  ifFiles = fs: optional (hasFiles fs);
  ifFilesAndNot = fs: fs2: optional (hasFiles fs && !hasFiles fs2);
  file = f: path + ("/" + f);
  read = f: optionalString (hasFiles f) (readFile (file f));
  hasSource = hasFiles "source";
  source = if hasSource then removeSuffix "\n" (read "source") else null;

  nle-conf = fixSelfWith (import ./nle.nix) { source = path; inherit pkgs; };
  nleFiles = name: ifFilesAndNot
    "${nle-conf.${name}.files or ""} ${nle-conf.${name}.generated or ""}"
    (nle-conf.notFiles or "");

  wrapScriptWithPackages = src: env: rec {
    text = read src;
    name = baseNameOf src;
    lines = splitString "\n" text;
    pkgsMark = " with-packages ";
    pkgsLines = map
      (x: splitString pkgsMark x)
      (filter (hasInfix pkgsMark) lines);
    pkgsNames = flatten (map (x: splitString " " (elemAt x 1)) pkgsLines);
    buildInputs = map (x: getAttrFromPath (splitString "." x) pkgs) pkgsNames ++ build-paths;
    selfHash = hashString "sha256" self-path;
    makeScriptText = replaceStrings
      [ "CFG_STORE_PATH" "NIX_LOCAL_ENV_HASH" ]
      [ self-path selfHash ];
    isBash = hasSuffix "bash" (head lines);
    script = writeScript "${name}-unwrapped" (makeScriptText text);
    scriptTail = makeScriptText (concatStringsSep "\n" (tail lines));
    contents =
      if hasSource
      then ''exec ${source}/${src} "$@"''
      else if isBash then scriptTail else ''exec ${script} "$@"'';
    out = writeBashBin name ''
      export ${pathAdd buildInputs}
      ${contents}
    '';
  }.out;

  localfile = file "local.nix";
  local-bin-pkgs =
    optionalAttrs
      (hasFiles "bin")
      (mapAttrs (x: _: hiPrio (wrapScriptWithPackages "bin/${x}" { })) (readDir (file "bin")));
  local-bin-paths = attrValues local-bin-pkgs;
  local-nix = rec {
    imported = import localfile;
    result = if isFunction imported then imported pkgs else imported;
    out = if pathExists localfile then result else null;
  }.out;
  local-nix-paths = ifFiles "local.nix" [ local-nix.paths or local-nix ];
  node-modules-paths =
    ifFilesAndNot "package.json package-lock.json node-packages.nix" "yarn.nix yarn.lock"
      (lowPrio nle-conf.npm.out);

  yarn-paths = nleFiles "yarn"
    rec {
      package = (yarn2nix-moretea.override { nodejs = nodejs_latest; }).mkYarnModules rec {
        name = pname;
        pname = "yarn-modules";
        version = "";
        packageJSON = file "package.json";
        yarnLock = file "yarn.lock";
        yarnNix = file "yarn.nix";
      };
      out = runCommand "yarn-env" { passthru = { inherit package; }; } ''
        mkdir $out
        [[ -e ${package}/node_modules/.bin ]] && ln -s ${package}/node_modules/.bin $out/bin
        ln -s ${package}/node_modules $out/node_modules
      '';
    }.out;

  bundler-paths = nleFiles "bundler"
    rec {
      env = bundlerEnv {
        name = "bundler-env";
        gemdir = buildDir (map file (words "Gemfile Gemfile.lock gemset.nix"));
        groups = null;
        gemConfig = defaultGemConfig // {
          zipruby = _: { buildInputs = [ zlib ]; };
          grpc = attrs: override (defaultGemConfig.grpc attrs) {
            AROPTS = "-r";
          };
          plivo = _: { nativeBuildInputs = [ rake ]; };
          mimemagic = _: {
            FREEDESKTOP_MIME_TYPES_PATH = "${mime-types}/etc/mime.types";
            nativeBuildInputs = [ rake ];
          };
          rmagick = attrs: override (defaultGemConfig.rmagick attrs) {
            buildInputs = [ imagemagick6 ];
          };
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
      nle-conf.pip.out;

  poetry-paths =
    nleFiles "poetry" (override nle-conf.poetry.out { name = "poetry-env"; });

  build-paths = flatten [
    local-nix-paths
    bundler-paths
    node-modules-paths
    yarn-paths
    mach-nix-paths
    poetry-paths
  ];

  paths = flatten [ build-paths local-bin-paths ];

  packages = listToAttrs (map (x: { name = x.name; value = x; }) build-paths) // local-bin-pkgs;

  out = buildEnv {
    name = "local-env";
    inherit paths;
    ignoreCollisions = true;
    passthru = {
      inherit paths;
      pkgs = packages;
    };
  };
}.out
