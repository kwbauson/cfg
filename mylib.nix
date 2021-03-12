prev: with prev; with lib; with builtins;
cli // generators // lib // builtins // rec {
  inherit (writers) writeBash writeBashBin;
  ap = x: f: f x;
  mapAttrValues = f: mapAttrs (n: v: f v);
  inherit (stdenv) isLinux isDarwin;
  sources = import ./nix/sources.nix { inherit system pkgs; };
  exe = pkg:
    let b = removePrefix "node_" (pkg.pname or (parseDrvName pkg.name).name);
    in "${pkg}/bin/${b}";
  prefixIf = b: x: y: if b then x + y else y;
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
    then x:
      let
        cmd = if isDerivation x then exe x else x;
        pre = if any (s: hasInfix s x) [ "&&" "||" ";" ] then "" else "exec";
      in
      writeBashBin name ''${pre} ${cmd} "$@"''
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
  importNixpkgs = src:
    let realSrc =
      if src ? type && src.type == "file" && src ? url_template && hasInfix ".tar." src.url_template
      then unpack src else src;
    in import realSrc { inherit system; config = import ./config.nix; overlays = [ ]; };
  buildDir = paths:
    let cmds = concatMapStringsSep "\n" (p: "cp -r ${p} $out/${baseNameOf p}") (toList paths);
    in runCommand "build-dir" { } "mkdir $out\n${cmds}";
  copyPath = path: runCommand (baseNameOf path) { } "cp -Lr ${path} $out && chmod -R +rw $out";
  nodeEnv = callPackage "${sources.node2nix}/nix/node-env.nix" { nodejs = nodejs_latest; };
  pathAdd = pkgs: "PATH=${makeBinPath (toList pkgs)}:$PATH";
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
  importDir = dir:
    let
      path = p: dir + "/${p}";
      importPath = p: import (path p);
      hasPath = p: pathExists (path p);
      importEntry = name: value:
        if hasSuffix ".nix" name
        then { name = removeSuffix ".nix" name; value = importPath name; }
        else if hasPath "${name}/default.nix"
        then { inherit name; value = importPath name; }
        else if hasPath "${name}/configuration.nix"
        then { inherit name; value = importPath "${name}/configuration.nix"; }
        else null;
    in
    mapDirEntries importEntry dir;
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
    };
}
