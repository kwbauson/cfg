{ pkgs, config, self, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      timeout = 1;
    };
    tmpOnTmpfs = true;
  };

  nix.package = self.packages.${pkgs.system}.nixMaster;
  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://kwbauson.cachix.org
    extra-trusted-public-keys = kwbauson.cachix.org-1:vwR1JZD436rg3cA/AeE6uUbVosNT4zCXqAmmsVLW8ro=
    builders-use-substitutes = true
  '';
  # nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "eu.nixbuild.net";
    system = "x86_64-linux";
    maxJobs = 100;
    supportedFeatures = [ "benchmark" "big-parallel" ];
  }];
  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      IdentityFile /root/.ssh/id_ed25519
  '';

  nixpkgs.config = import ../config.nix;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  console = {
    earlySetup = true;
    font = "default8x16";
  };

  fonts.enableDefaultFonts = config.services.xserver.enable;

  services = {
    localtime.enable = true;
    tlp.enable = false;
    logind.lidSwitch = "ignore";
    journald.extraConfig = "SystemMaxUse=100M";
    xserver.displayManager = if !config.services.xserver.enable then { } else {
      defaultSession = "none+xsession";
      autoLogin = {
        enable = true;
        user = "keith";
      };
      session = [
        {
          manage = "window";
          name = "xsession";
          start = "exec ~/.xsession";
        }
      ];
      lightdm.enable = true;
    };
  };

  users = {
    users = {
      keith = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "adbusers" "docker" "vboxusers" "video" ];
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "21.03";
  programs.command-not-found.dbPath = self.programs-sqlite;
}
