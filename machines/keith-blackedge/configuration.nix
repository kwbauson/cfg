{ scope, ... }: with scope;
{
  imports = [
    ./hardware-configuration.nix
    "${cobi.src}/hosts/modules/conf/blackedge.nix"
  ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.loader.timeout = 5;

  nix.settings = {
    extra-substituters = [ "https://blackedge-nix.s3.us-east-2.amazonaws.com" ];
    extra-trusted-public-keys = [ "blackedge-nix.s3.us-east-2.amazonaws.com:1MDUZHbXmD18H1RJYRo7Fy4prdg+xjyyKm8CUjrOj5w=" ];
  };

  users = {
    mutableUsers = false;
    users.jacobi = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPasswordFile = "/etc/passwordFile-jacobi";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkME8cVp908fLcQiSYmwSruCBcm4iBR8CS87s8AqNmK jacobi@edge"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhuYfq5mWapXMTPckVlstMYBqGG4J7IBMgmGNQAhn1q devops@blackedge"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBuRcUxCy38pPQfU4tS+M23BSsGehhOF2tgRJy6LzUc"
      ];
    };
  };

  conf.blackedge.enable = true;

  networking = {
    firewall.enable = false;
    hostName = "cy1-kbauson-01";
    nameservers = [ "10.31.65.200" "1.1.1.1" ];
    search = [ "blackedge.local" ];
    networkmanager.enable = false;
  };

  programs.command-not-found.enable = false;
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
      PasswordAuthentication = true;
    };
  };
  swapDevices = [{ device = "/swapfile"; size = 1024; }];
  time.timeZone = "America/Chicago";
  users.users.root.hashedPassword = "!";
  virtualisation.vmware.guest.enable = true;
  system.stateVersion = "24.05";

  users.users.keith.openssh.authorizedKeys.keys = mkForce [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXTCckeJ1gBp+IASGnvwkAp1HuobNvrMr7SNU0xgwPd keith-blackedge-access"
  ];

  services.auto-update.enable = true;

  services._3proxy = {
    enable = true;
    services = [{
      type = "socks";
      auth = [ "none" ];
    }];
  };
}
