final: prev:
let
  extra-packages = with prev.scope-lib; mapAttrs
    (n: f: prev.scope.callPackage f (
      if lib.functionArgs f == { }
      then prev.scope // rec {
        name = "${pname}-${version}";
        pname = n;
        version = src.version or src.rev or "unversioned";
        src = prev.scope.sources.${n} or null;
        ${n} = prev.${n};
      }
      else { }
    ))
    (filterAttrs (_: v: !isPath v) (import' ../pkgs));
  # make this not assume you're working from nixpkgs root
  patched-update-nix = with prev.scope; runCommand "patched" { } ''
    cp ${pkgs.path}/maintainers/scripts/update.nix $out
    patch $out ${./update-nix.patch}
  '';
in
{
  inherit patched-update-nix;
  defaultUpdateScript = final.nix-update-script { extraArgs = [ "--flake" ]; };
  update-extra-packages = import patched-update-nix {
    pkgs = final;
    package = "extra-packages.slapper";
    # path = "extra-packages";
  };
  inherit extra-packages;
} // extra-packages
