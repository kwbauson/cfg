{ config, scope, machine-name, username, isGraphical, ... }: with scope;
{
  imports = [
    modules.common-system
    machines.${machine-name}.configuration
    machines.${machine-name}.hardware-configuration
    inputs.home-manager.nixosModules.default
  ] ++ attrValues (importDir ./.);

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = mkDefault true;
        configurationLimit = mkDefault 5;
        consoleMode = "auto";
      };
      timeout = mkDefault 1;
    };
    tmp.useTmpfs = true;
    supportedFilesystems = [ "ntfs" ];
    kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
  };

  system.nixos.label = flakeLastModifiedDateString;

  nix.channel.enable = false;
  networking.networkmanager.enable = mkDefault true;
  networking.networkmanager.wifi.powersave = mkDefault false;
  networking.hostName = mkDefault machine-name;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services.resolved.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 100;
  };

  console = {
    earlySetup = true;
    font = "default8x16";
  };

  fonts.enableDefaultPackages = mkDefault isGraphical;

  time.timeZone = mkDefault "America/Indianapolis";

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = isGraphical;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire-pulse."10-switch-on-connect"."pulse.cmd" = [{
        cmd = "load-module";
        args = "module-switch-on-connect";
      }];
    };
    dbus.packages = [ dconf ];
    tlp.enable = false;
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "ignore";
    };
    journald.extraConfig = "SystemMaxUse=100M";
    displayManager = mkIf isGraphical {
      defaultSession = "none+xsession";
      autoLogin = {
        enable = mkDefault true;
        user = username;
      };
    };
    xserver.enable = mkDefault isGraphical;
    xserver.displayManager = mkIf isGraphical {
      session = [
        {
          manage = "window";
          name = "xsession";
          start = "exec ~/.xsession";
        }
      ];
      lightdm.enable = mkDefault true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "dialout" ];
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = mkDefault "25.05";
  programs.command-not-found.enable = false;
  programs.steam.enable = mkDefault isGraphical;
  programs.pmount.enable = true;
  services.openssh.enable = true;
  services.openssh.openFirewall = false;
  services.tailscale.enable = mkDefault true;
  services.tailscale.useRoutingFeatures = mkDefault "client";
  systemd.services.tailscaled.after = [ "systemd-networkd-wait-online.service" ];
  hardware.bluetooth.enable = mkDefault isGraphical;
  programs.i3lock.enable = true;
  services.smartd.enable = mkDefault true;
  services.earlyoom.enable = true;

  services.udev.packages = optionals isGraphical [ headsetcontrol ];
  services.openssh.settings = {
    PasswordAuthentication = mkDefault false;
    PermitRootLogin = "no";
    X11Forwarding = true;
    KexAlgorithms = [
      "mlkem768x25519-sha256"
      "sntrup761x25519-sha512"
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

  services.evremap.settings.remap = [
    { input = [ "KEY_CAPSLOCK" ]; output = [ "KEY_LEFTCTRL" ]; }
    { input = [ "KEY_LEFTALT" ]; output = [ "KEY_ESC" ]; }
    { input = [ "KEY_COMPOSE" ]; output = [ "KEY_RIGHTMETA" ]; }
  ];

  services._3proxy.services = [{
    type = "socks";
    auth = [ "none" ];
    bindAddress = constants.${machine-name}.tailscale-ip;
  }];
}
