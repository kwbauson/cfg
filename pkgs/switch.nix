scope: with scope;
let
  scripts = forAttrValues machines (machine@{ isNixOS, isNixDarwin, ... }:
    let
      kind = if isNixOS then "nixos" else if isNixDarwin then "darwin" else null;
      toplevel = {
        nixos = nixosConfigurations.${machine.name}.config.system.build.toplevel;
        darwin = darwinConfigurations.${machine.name}.system;
      }.${kind};
      mkAction = action: (writeBashBin "switch" (''
        set -euo pipefail
        profile=/nix/var/nix/profiles/system
        ${getExe nvd} diff "$profile" ${toplevel}
      '' + {
        nixos = ''
          sudo nixos-rebuild --no-reexec --store-path ${toplevel} ${action}
        '';
        darwin = ''
          sudo -H nix-env -p "$profile" --set ${toplevel}
          sudo ${toplevel}/activate
        '';
      }.${kind})).overrideAttrs { name = "${action}-${toplevel.name}"; };
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
    ${getExe cached-refs} kwbauson checks.${system} shell . "switch.scripts.$(machine-name).${name}" -c switch
  '';
in
buildEnv {
  name = pname;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
  meta.includePackage = true;
}
