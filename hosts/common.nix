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

  boot.blacklistedKernelModules = [ "psmouse" ];

  nix.package = pkgs.nixUnstable;
  nix.nixPath = [ ];
  nix.extraOptions = self.nixConf;
  # nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "beta.nixbuild.net";
    system = "x86_64-linux";
    maxJobs = 100;
    supportedFeatures = [ "benchmark" "big-parallel" ];
  }];
  programs.ssh.extraConfig = ''
    Host beta.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      IdentityFile /root/.ssh/id_ed25519
  '';
  networking.networkmanager.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  nixpkgs = { inherit (self) config overlays; };

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
    dbus.packages = with pkgs; [ gnome3.dconf ];
    localtime.enable = true;
    chrony.enable = true;
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
    autorandr.enable = true;
    earlyoom.enable = true;
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
  system.stateVersion = "21.05";
  programs.command-not-found.dbPath = self.programs-sqlite;
}
