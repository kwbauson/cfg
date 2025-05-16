final: prev: with final.scope;
let
  extra-packages = with prev.scope-lib; pipe ../pkgs [
    readDir
    attrNames
    (map (path:
      let isPkgDir = pathExists (../pkgs + "/${path}/default.nix"); in
      {
        name = if isPkgDir || hasSuffix ".nix" path then removeSuffix ".nix" path else null;
        value = ../pkgs + ("/" + (if isPkgDir then "${path}/default.nix" else path));
      })
    )
    (filter (x: x.name != null))
    listToAttrs
    (mapAttrs (pname: path: pipeValue [
      (final.scope // { inherit pname; version = "unstable"; prev = prev.${pname}; })
      (optionalAttrs (functionArgs (import path) == { }))
      (prev.callPackage path)
      (addMetaAttrs { position = "${toString path}:1"; })
      (attrs: attrs // optionalAttrs (hasAttr pname prev) { prev = prev.${pname}; })
    ]))
  ];
in
{
  compatGetFlake = src: (import inputs.flake-compat { inherit src; }).defaultNix;
  compatGetFlakeDefault = src: (compatGetFlake src).packages.${system}.default;
  inherit extra-packages;
  importPackage = arg:
    (attrs: mergeAttrsList [
      { name = "${attrs.pname}-${attrs.version}"; }
      (optionalAttrs (attrs ? package) {
        type = "derivation";
        inherit (attrs.package) drvPath outPath out outputName meta;
      })
      (filterAttrs (n: _: elem n [ "package" "__functor" ]) attrs)
      attrs
      (attrs.passthru or { })
    ]) ((if isFunction arg then fix else id) arg);
} // extra-packages
