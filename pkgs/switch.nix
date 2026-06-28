scope: with scope;
let
  scripts = forAttrValues machines (machine@{ isNixOS, isNixDarwin, ... }:
    let
      osConfigurations =
        if isNixOS then nixosConfigurations
        else if isNixDarwin then darwinConfigurations
        else null;
      inherit (osConfigurations.${machine.name}) config;
      inherit (config.system) build;
      inherit (build) toplevel;
      mkAction = action: (writeBashBin "switch" (''
        set -euo pipefail
        profile=/nix/var/nix/profiles/system
        ${getExe dix} "$profile" ${toplevel}
      '' + optionalString isNixOS ''
        sudo ${getExe build.nixos-rebuild} --no-reexec --store-path ${toplevel} ${action}
      '' + optionalString isNixDarwin ''
        sudo -H nix-env -p "$profile" --set ${toplevel}
        sudo ${toplevel}/activate
      ''
      )).overrideAttrs { name = "${action}-${toplevel.name}"; };
    in
    {
      nob = mkAction "boot";
      noa = mkAction "switch";
    }
  );
  makeBin = name: writeBashBin name ''
    set -euo pipefail
    cd ~/cfg
    ${getExe git} add --all -N
    ${getExe cached-refs} "$@" . "packages.${system}.switch.scripts.$(machine-name).${name}" run
  '';
in
buildEnv {
  name = pname;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
  meta.includePackage = true;
}
