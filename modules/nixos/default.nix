{ scope, ... }: with scope;
{
  imports = [
    modules.common-configuration
    machine.configuration
    machine.hardware-configuration
    inputs.home-manager.nixosModules.default
  ] ++ attrValues (importDir ./.);

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = mkDefault true;
        configurationLimit = mkDefault 5;
        consoleMode = "auto";
        memtest86.enable = true;
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
  networking.hostName = mkDefault machine.name;
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

  services.keyd.keyboards.default.settings = {
    main = {
      capslock = "leftcontrol";
      leftalt = "escape";
    };
    "meta+control+shift" = {
      v = "toggle(vim)";
      s = "toggle(scroll)";
    };
    vim = {
      h = "left";
      j = "down";
      k = "up";
      l = "right";
    };
    scroll = {
      escape = "down";
      f1 = "up";
      "`" = "right";
      "1" = "left";
      mute = "up";
      delete = "down";
      insert = "up";
      backspace = "right";
      "=" = "left";
    };
  };

  services._3proxy.services = [{
    type = "socks";
    auth = [ "none" ];
    bindAddress = machine.tailscale-ip;
  }];
}
