{ config, scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.common-system
    machines.${machine-name}.configuration
    machines.${machine-name}.hardware-configuration
    inputs.home-manager.nixosModule
  ] ++ attrValues (importDir ./.);

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
    tmp.useTmpfs = true;
    supportedFilesystems = [ "ntfs" ];
  };

  nixpkgs = { inherit (pkgs) pkgs config; };
  networking.networkmanager.enable = mkDefault true;
  networking.networkmanager.wifi.powersave = mkDefault false;
  networking.hostName = mkDefault machine-name;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  systemd.services.NetworkManager-wait-online.enable = mkDefault false;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

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

  time = mkIf config.time.hardwareClockInLocalTime {
    timeZone = "America/Indianapolis";
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    dbus.packages = [ dconf ];
    localtimed.enable = mkDefault (!config.time.hardwareClockInLocalTime);
    chrony.enable = true;
    tlp.enable = false;
    logind.lidSwitch = "ignore";
    journald.extraConfig = "SystemMaxUse=100M";
    xserver.enable = mkDefault true;
    xserver.displayManager = mkIf config.services.xserver.enable {
      defaultSession = "none+xsession";
      autoLogin = {
        enable = true;
        user = username;
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

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "dialout" ];
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "21.11";
  programs.command-not-found.enable = false;
  programs.steam.enable = mkDefault config.services.xserver.enable;
  programs.pmount.enable = true;
  services.tailscale.enable = mkDefault config.services.openssh.enable;
  hardware.bluetooth.enable = mkDefault config.services.xserver.enable;

  services.udev.packages = optionals config.services.xserver.enable [ headsetcontrol ];
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

  services.caddy.email = "kwbauson@gmail.com";
}
