let
  jacobi_src = fetchTarball {
    name = "jpetrucciani-2024-10-02";
    url = "https://github.com/jpetrucciani/nix/archive/780d3f87919af2b7d36fa4f41e16c7d605cf83c3.tar.gz";
    sha256 = "1h0yxhap82wx9wxq35jydjnas1alz2ybbqnmr1wwyzsc4lb1w020";
  };
  pkgs = import jacobi_src {};
in
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    "${jacobi_src}/hosts/modules/conf/blackedge.nix"
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };

  nix = {
    extraOptions = ''
      max-jobs = auto
      extra-experimental-features = nix-command flakes
      substituters = https://cache.nixos.org/ https://blackedge-nix.s3.us-east-2.amazonaws.com
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= blackedge-nix.s3.us-east-2.amazonaws.com:1MDUZHbXmD18H1RJYRo7Fy4prdg+xjyyKm8CUjrOj5w=
    '';
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
  };
  programs.command-not-found.enable = false;
  security.sudo.wheelNeedsPassword = false;
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };
  swapDevices = [{ device = "/swapfile"; size = 1024; }];
  system.copySystemConfiguration = true;
  system.stateVersion = "24.05";
  time.timeZone = "America/Chicago";
  users.users.root.hashedPassword = "!";
  virtualisation.vmware.guest.enable = true;
}
