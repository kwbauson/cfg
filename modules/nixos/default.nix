{ config, scope, ... }: with scope;
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

  system.nixos.label = cfgLastModifiedDateString;

  nix.channel.enable = false;
  networking.networkmanager.enable = mkDefault true;
  networking.networkmanager.wifi.powersave = mkDefault false;
  networking.hostName = mkDefault machine.name;
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  services.resolved.enable = true;
  services.speechd.enable = false;

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

  fonts = optionalAttrs isGraphical {
    enableDefaultPackages = true;
    packages = [ corefonts ];
  };

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

  users.mutableUsers = false;
  secrets.password.neededForUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "dialout" ];
    hashedPasswordFile = config.secrets.password.path;
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = mkDefault "26.11";
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
  systemd.services.keyd.serviceConfig.Group = "wheel";

  services._3proxy.services = [{
    type = "socks";
    auth = [ "none" ];
    bindAddress = machine.tailscale.ip;
  }];
}
