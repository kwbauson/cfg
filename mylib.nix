prev: with prev; with lib; with builtins;
cli // generators // lib // builtins // rec {
  inherit (writers) writeBash writeBashBin;
  ap = x: f: f x;
  mapAttrValues = f: mapAttrs (n: v: f v);
  inherit (stdenv) isLinux isDarwin;
  sources = import ./nix/sources.nix { inherit system pkgs; };
  exe = pkg:
    let b = (pkg.meta or { }).mainProgram or (removePrefix "node_" (pkg.pname or (parseDrvName pkg.name).name));
    in "${pkg}/bin/${b}";
  prefixIf = b: x: y: if b then x + y else y;
  desc = pkg: (x: trace "\n${concatStringsSep "\n" x}" null) [
    "  name: ${pkg.name or pkg.pname or "null"}"
    "  description: ${pkg.meta.description or "null"}"
    "  homepage: ${pkg.meta.homepage or "null"}"
  ];
  d = desc;
  mapLines = f: s: concatMapStringsSep "\n"
    (l: if l != "" then f l else l)
    (splitString "\n" s);
  words = string: filter (x: isString x && x != "") (split "[[:space:]]+" string);
  attrIf = check: name: if check then name else null;
  drvs = x: if isDerivation x || isList x then flatten x else flatten (mapAttrsToList (_: v: drvs v) x);
  drvsExcept = x: e: with {
    excludeNames = concatMap attrNames (attrValues e);
  }; flatten (drvs (filterAttrsRecursive (n: _: !elem n excludeNames) x));
  userName = "Keith Bauson";
  userEmail = "kwbauson@gmail.com";
  nixpkgs-branch = let urlParts = splitString "/" (import ./flake.nix).inputs.nixpkgs.url; in
    if length urlParts == 3 then elemAt urlParts 2 else "master";
  excludeLines = f: text: concatStringsSep "\n" (filter (x: !f x) (splitString "\n" text));
  unpack = src: stdenv.mkDerivation {
    src = if src ? url && src ? sha256 then fetchurl { inherit (src) url sha256; } else src;
    name = src.name or "source";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mv $PWD $out
    '';
  };
  runBin = name: script: runCommand
    name
    { } ''
    mkdir -p $out/bin
    ${exe (writeBashBin "script" script)} > $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
  alias = name:
    if isString name
    then arg:
      let
        cmd = if isDerivation arg then exe arg else arg;
        pre = if any (s: hasInfix s arg) [ "&&" "||" ";" "|" "\n" ] then "" else "exec";
        post = if any (s: hasInfix s arg) [ ''"$@"'' "\n" ] then "" else ''"$@"'';
      in
      writeBashBin name "${pre} ${cmd} ${post}"
    else mapAttrs alias name;
  mkDmgPackage = pname: src: stdenv.mkDerivation {
    name = pname + (if src ? version then "-${src.version}" else "");
    inherit pname src;
    ${attrIf (src ? version) "version"} = src.version;
    dontUnpack = true;
    nativeBuildInputs = [ undmg ];
    installPhase = ''
      mkdir -p $out/{Applications,bin}
      undmg "$src"
      mv *.app $out/Applications
      appdir=$(echo $out/Applications/*.app)
      [[ -d $appdir ]] || exit 1
      exe=$appdir/Contents/MacOS/${pname}
      echo '#!/bin/sh' > $out/bin/${pname}
      if [[ -e $exe ]];then
        echo "exec \"$exe\" \"\$@\"" >> $out/bin/${pname}
      else
        echo "exec open -a $out/Applications/*.app \"\$@\"" >> $out/bin/${pname}
      fi
      chmod +x $out/bin/${pname}
    '';
  };
  dmgOverride = name: pkg: with rec {
    src = sources."dmg-${name}";
    msg = "${name}: src ${src.version} != pkg ${pkg.version}";
    checkVersion = lib.assertMsg (pkg.version == src.version) msg;
  }; if isDarwin then assert checkVersion; (mkDmgPackage name src) // { originalPackage = pkg; } else pkg;
  importNixpkgs = src: import src { inherit system; config = import ./config.nix; overlays = [ ]; };
  buildDir = paths:
    let
      copyCommand = p: "cp -r ${builtins.path { name = "source"; path = p; }} $out/${baseNameOf p}";
      cmds = concatMapStringsSep "\n" copyCommand (toList paths);
    in
    runCommand "source" { } "mkdir $out\n${cmds}";
  buildDirExcept = path: except: buildDir (map (x: path + ("/" + x)) (
    filter
      (x: ! any (y: y == x) (toList except))
      (attrNames (readDir path))
  ));
  nodeEnv = callPackage "${inputs.nixpkgs}/pkgs/development/node-packages/node-env.nix" { nodejs = nodejs_latest; };
  pathAdd = pkgs: "export PATH=${makeBinPath (toList pkgs)}:$PATH";
  makeScript = name: script: writeBashBin name (if isDerivation script then ''exec ${script} "$@"'' else "set -e\n" + script);
  makeScripts = mapAttrs makeScript;
  echo = text: writeBash "echo-script" ''echo "$(< ${toFile "text" text})"'';
  attrsToList = mapAttrsToList (name: value: { inherit name value; });
  joinStrings = sep: f: g: concatMapStringsSep sep (s: if isString s then f s else g (head s) (lib.last s));
  joinLines = joinStrings "\n";
  override = x: y:
    if y ? _replace then y._replace
    else if y ? _append then x + y._append
    else if isList x && isList y then x ++ y
    else if isDerivation x && isPath y && pathExists y then y
    else if isDerivation x && isPath y && !pathExists y then x
    else if isDerivation x && isAttrs y then
      override x.overrideAttrs y
    else if isFunction x && isAttrs y then
      x (attrs: mapAttrs (n: v: if hasAttr n attrs then override attrs.${n} v else v) y)
    else if isAttrs x && isAttrs y then
      mapAttrs (n: v: if hasAttr n y then override v y.${n} else v) (y // x)
    else y;
  mapDirEntries = f: dir: listToAttrs (filter (x: x != null && x != { }) (mapAttrsToList f (readDir dir)));
  import' = path:
    let importEntry = entry: type:
      if type == "directory" then
        let
          mkEntry = file: type: {
            name = removeSuffix ".nix" file;
            value = importEntry (entry + "/${file}") type;
          };
          entries = listToAttrs (mapAttrsToList mkEntry (readDir entry));
          default = entries.default or { };
        in
        if isAttrs default then default // entries
        else if isFunction default then entries // { __functor = _: default; __functionArgs = functionArgs default; }
        else default
      else if hasSuffix ".nix" entry then import entry
      else entry;
    in
    importEntry path "directory";
  fixSelfWith = f: x:
    let self = f (x // { inherit self; }); in self;
  writeBashBinChecked = name: text: stdenv.mkDerivation {
    inherit name text;
    dontUnpack = true;
    passAsFile = "text";
    installPhase = ''
      mkdir -p $out/bin
      echo '#!/bin/bash' > $out/bin/${name}
      cat $textPath >> $out/bin/${name}
      chmod +x $out/bin/${name}
      ${shellcheck}/bin/shellcheck $out/bin/${name}
    '';
  };
  wrapBins = pkg: script:
    let wrapped = stdenv.mkDerivation {
      name = "${pkg.name}-wrapped";
      inherit script;
      passAsFile = "script";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cd ${pkg}/bin
        for exe in *;do
          echo '#!/usr/bin/env bash' > $out/bin/$exe
          echo "exe=$exe" >> $out/bin/$exe
          echo "exePath=${pkg}/bin/$exe" >> $out/bin/$exe
          cat $scriptPath >> $out/bin/$exe
          chmod +x $out/bin/$exe
        done
      '';
    }; in
    buildEnv {
      name = wrapped.name;
      ignoreCollisions = true;
      paths = [ wrapped pkg ];
      passthru = pkg.passthru // { unwrapped = pkg; };
      meta.mainProgram = baseNameOf (exe pkg);
    };
}
