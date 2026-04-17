final: prev: with final.scope; {
  nix-index-list = stdenv.mkDerivation {
    name = "nix-index-list";
    extra =
      let
        extraPackages = set: concatMapStringsSep "\n" (n: "${set}.${n} ${n}") (attrNames (pkgs.${set}));
        extra-set-list = concatMapStringsSep "\n" extraPackages
          [ "python3Packages" "rubyPackages" ];
        base-list = concatMapStringsSep "\n" (n: "${n} ${n}") (attrNames pkgs);
      in
      base-list + extra-set-list;
    passAsFile = "extra";
    dontUnpack = true;
    buildInputs = [ nix-index ];
    installPhase = ''
      nix-locate  \
        --db ${nix-index-database} \
        --at-root \
        --type x --type s \
        --regex '/bin/[^.][^/]*' |
        grep -v '^(' |
        awk '{ print $1, $4 }' |
        sed -E 's#^(.*)\.\w+ .*/([^/]+)$#\1 \2#' > list
      sort list $extraPath | uniq > $out
    '';
  };
  steam-native = steam.override { nativeOnly = true; };
  nle-cfg = nle.build { path = cfgRoot; };
  inherit (nle-cfg.pkgs) fordir;
  inherit (nle-cfg.pkgs.poetry-env.python.pkgs) git-remote-codecommit;
  iso = with packages.x86_64-linux; (nixos ({ modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
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
