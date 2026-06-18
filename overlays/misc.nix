final: prev: with final.scope; {
  pkgsUnsupported = importNixpkgs { config = root.config // { allowUnsupportedSystem = true; }; };
  pkgsInsecure = importNixpkgs { config = root.config // { allowInsecurePredicate = _: true; }; };
  inherit (extra-bin-packages) fordir;
  configdiffNix = cfg.outPath;
  configdiffNixAttr = "configdiff";
  iso = with packages.x86_64-linux; (nixos ({ modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    environment.systemPackages = [ better-comma ];
  })).config.system.build.isoImage;
}
