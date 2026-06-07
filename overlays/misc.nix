final: prev: with final.scope; {
  pkgsUnsupported = importNixpkgs { config = root.config // { allowUnsupportedSystem = true; }; };
  pkgsInsecure = importNixpkgs { config = root.config // { allowInsecurePredicate = _: true; }; };
  inherit (extra-bin-packages) fordir;
  iso = with packages.x86_64-linux; (nixos ({ modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    environment.systemPackages = [ better-comma ];
  })).config.system.build.isoImage;

  vmConsole = configuration:
    let
      vm = (nixos {
        services.getty.autologinUser = "root";
        system.stateVersion = "25.05";
        imports = [ configuration ];
      }).config.system.build.vm;
    in
    writeBashBin "vm-console" ''${getExe vm} --nographic "$@"'';
}
