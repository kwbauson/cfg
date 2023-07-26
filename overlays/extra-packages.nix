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
      (final.scope // { inherit pname; prev = prev.${pname}; })
      (optionalAttrs (functionArgs (import path) == { }))
      (prev.callPackage path)
      (addMetaAttrs { position = "${toString path}:1"; })
    ]))
  ];
in
{
  inherit extra-packages;
  # make this not assume you're working from nixpkgs root
  patched-update-nix = runCommand "patched" { } ''
    cp ${pkgs.path}/maintainers/scripts/update.nix $out
    patch $out ${./update-nix.patch}
  '';
  importPackage = arg:
    (attrs: mergeAttrsList [
      { name = "${attrs.pname}-${attrs.version}"; }
      (optionalAttrs (attrs ? package) {
        type = "derivation";
        inherit (attrs.package) drvPath outPath;
      })
      attrs
      (attrs.passthru or { })
    ]) ((if isFunction arg then fix else id) arg);
  package-updater = args: writeBashBin "updater" ''
    ${pathAdd [ curl ]}
    echo | ${getExe (import patched-update-nix ({ inherit pkgs; } // args))}
  '';
  update-extra-packages = (package-updater {
    path = "extra-packages";
  }).overrideAttrs (_: {
    passthru = forAttrNames extra-packages (name:
      package-updater {
        package = "extra-packages.${name}";
      }
    );
  });
} // extra-packages

