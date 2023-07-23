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
    (mapAttrs (pname: path:
      prev.callPackage path
        (optionalAttrs (functionArgs (import path) == { }) (final.scope // rec {
          inherit pname;
          version = src.version or src.rev or "unversioned";
          name = "${pname}-${version}";
          src = prev.scope.sources.${pname} or null;
          ${pname} = prev.${pname};
        }))
      // {
        meta = prev.${pname}.meta or { } // {
          position = "${toString path}:1";
        };
      }
    ))
  ];
in
{
  inherit extra-packages;
  # make this not assume you're working from nixpkgs root
  patched-update-nix = with prev.scope; runCommand "patched" { } ''
    cp ${pkgs.path}/maintainers/scripts/update.nix $out
    patch $out ${./update-nix.patch}
  '';
  importPackage = arg:
    (attrs: {
      name = "${attrs.pname}-${attrs.version}";
      inherit (attrs.package) type drvPath outPath;
    } // attrs // attrs.passthru or { }) ((if isFunction arg then fix else id) arg);
  update-extra-packages = (import patched-update-nix {
    inherit pkgs;
    path = "extra-packages";
  }).overrideAttrs (_: {
    passthru = forAttrNames extra-packages (name:
      import patched-update-nix {
        inherit pkgs;
        package = "extra-packages.${name}";
      }
    );
  });
} // extra-packages

