{ config, scope, ... }: with scope;
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = mkDefault true;
        configurationLimit = mkDefault 5;
        consoleMode = "auto";
      };
      timeout = 1;
    };
    tmpOnTmpfs = true;
    supportedFilesystems = [ "ntfs" ];
  };

  environment.etc."nixpkgs-path".source = pkgs.path;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings.trusted-users = [ "@wheel" ];
  nix.extraOptions = nixConf;
  networking.networkmanager.enable = mkDefault true;
  systemd.services.NetworkManager-wait-online.enable = mkDefault false;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  nixpkgs = { inherit pkgs; inherit (pkgs) config; };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  console = {
    earlySetup = true;
    font = "default8x16";
  };

  fonts.enableDefaultFonts = config.services.xserver.enable;
  location.provider = "geoclue2";

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    dbus.packages = [ dconf ];
    localtimed.enable = mkDefault true;
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
    earlyoom.enable = true;
  };

  users = {
    users.keith = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "adbusers" "docker" "vboxusers" "video" "vboxsf" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "21.11";
  programs.command-not-found.enable = false;
  programs.steam.enable = mkDefault true;
  imports = [ ../modules/pmount.nix ];
  programs.pmount.enable = true;

  services.udev.packages = [ headsetcontrol ];
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = true;
    KexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
    ];
    Ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes256-ctr"
    ];
    Macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };
}
