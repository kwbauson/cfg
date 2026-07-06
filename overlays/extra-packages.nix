final: prev: with final.scope;
let
  extra-packages = with prev.scope'; pipeValue [
    (readDir ../pkgs)
    attrNames
    (map (path:
      let
        packagePkgFile = ../pkgs/${path}/package.nix;
        defaultPkgFile = ../pkgs/${path}/default.nix;
        pkgFile = if pathExists packagePkgFile then packagePkgFile else defaultPkgFile;
        isPkgDir = pathExists pkgFile;
      in
      {
        name = if isPkgDir || hasSuffix ".nix" path then removeSuffix ".nix" path else null;
        value = if isPkgDir then pkgFile else ../pkgs/${path};
      })
    )
    (filter (x: x.name != null))
    listToAttrs
    (mapAttrs (pname: path: pipeValue [
      (final.scope // {
        inherit pname;
        version = "unstable";
        package = extra-packages.${pname};
        exe = getExe extra-packages.${pname};
      })
      (optionalAttrs (functionArgs (import path) == { }))
      (callPackage path)
      (addMetaAttrs { position = "${toString path}:1"; })
      (p: addMetaAttrs (optionalAttrs (p.meta.mainProgram or null == null) { mainProgram = pname; }) p)
    ]))
  ];
in
{
  inherit extra-packages;
  extra-bin-packages = pipeValue [
    (readDir ../bin)
    (mapAttrs (n: _: readFile ../bin/${n}))
    (filterAttrs (_: t: isLinux || !hasInfix "ONLY_LINUX" t))
    (mapAttrs (name: text: (writeScriptBin name text).overrideAttrs (old: {
      nativeBuildInputs = [ makeWrapper ];
      PATH_ADD = pipeValue [
        (splitString "\n" text)
        (filter (hasInfix " with-packages "))
        (map (s: elemAt (splitString " with-packages " s) 1))
        (concatMap (splitString " "))
        (map (n: getAttrFromPath (splitString "." n) pkgs))
        makeBinPath
      ];
      buildCommand = /* bash */ ''
        ${old.buildCommand}
        if [[ -n $PATH_ADD ]];then
          wrapProgram $out/bin/${name} --prefix PATH : "$PATH_ADD"
        fi
      '';
    })))
  ];
  importPackage = arg:
    (attrs: mergeAttrsList [
      attrs
      { name = "${attrs.pname}-${attrs.version or "unstable"}"; }
      (optionalAttrs (attrs ? package) rec {
        type = "derivation";
        package = addMetaAttrs (attrs.meta or { }) attrs.package;
        inherit (package) drvPath outPath out outputName meta;
      })
      (filterAttrs (n: _: elem n [ "package" "__functor" ]) attrs)
      (attrs.passthru or { })
    ]) ((if isFunction arg then fix else id) arg);
} // extra-packages
