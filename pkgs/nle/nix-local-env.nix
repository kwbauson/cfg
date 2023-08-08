{ path, pkgs, source }: with pkgs.scope; rec {
  hasFiles = fs: words fs != [ ] && all (f: pathExists (file f)) (words fs);
  ifFiles = fs: optional (hasFiles fs);
  ifFilesAndNot = fs: fs2: optional (hasFiles fs && !hasFiles fs2);
  file = f: path + ("/" + f);
  read = f: optionalString (hasFiles f) (readFile (file f));
  hasSource = source != null;

  wrapScriptWithPackages = src: env: rec {
    text = read src;
    name = baseNameOf src;
    lines = splitString "\n" text;
    pkgsMark = " with-packages ";
    pkgsLines = map
      (x: splitString pkgsMark x)
      (filter (hasInfix pkgsMark) lines);
    pkgsNames = flatten (map (x: splitString " " (elemAt x 1)) pkgsLines);
    buildInputs = map (x: getAttrFromPath (splitString "." x) pkgs) pkgsNames ++ local-nix-paths;
    makeScriptText = replaceStrings [ "SELF_FLAKE" ] [ "${self-flake}" ];
    isBash = hasSuffix "bash" (head lines);
    script = stdenv.mkDerivation {
      name = "${name}-unwrapped";
      text = makeScriptText text;
      inherit buildInputs;
      passAsFile = "text";
      dontUnpack = true;
      installPhase = ''
        cp $textPath $out
        chmod +x $out
      '';
    };
    scriptTail = makeScriptText (concatStringsSep "\n" (tail lines));
    contents =
      if hasSource
      then ''exec ${source}/${src} "$@"''
      else if isBash then scriptTail else ''exec ${script} "$@"'';
    out = writeBashBin name ''
      export PATH_added=${makeBinPath buildInputs}
      export ${pathAdd buildInputs}
      ${contents}
    '';
  }.out;

  fileForPlatform = n: !isLinux && hasInfix "ONLY_LINUX" (read n);
  localfile = file "local.nix";
  local-bin-pkgs =
    optionalAttrs
      (hasFiles "bin")
      (mapAttrs (x: _: wrapScriptWithPackages "bin/${x}" { }) (filterAttrs (n: v: !fileForPlatform "bin/${n}") (readDir (file "bin"))));
  local-bin-paths = attrValues local-bin-pkgs;
  local-nix = rec {
    imported = import localfile;
    scope = pkgs.scope // { inherit source; };
    result = if isFunction imported then imported scope else imported;
    out = if pathExists localfile then result else null;
  }.out;
  local-nix-paths = ifFiles "local.nix" [ local-nix.paths or local-nix ];

  paths = flatten [ local-bin-paths local-nix-paths ];

  packages = listToAttrs (map (x: { name = x.pname or name; value = x; }) local-nix-paths) // local-bin-pkgs;

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
