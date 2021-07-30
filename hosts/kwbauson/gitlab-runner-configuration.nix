{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = true; # 1
  services.gitlab-runner = {
    enable = true;
    concurrent = 8;
    services = {
      nix = with pkgs; {
        tagList = [ "nix" ];
        registrationConfigFile = "/etc/nixos/gitlab-runner-secrets";
        dockerImage = "debian:stable";
        dockerDisableCache = true;
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
          "/var/lib/gitlab-runner/cache:/cache"
        ];
        preCloneScript = pkgs.writeScript "setup-container" ''
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
        '';
        environmentVariables = {
          NIX_REMOTE = "daemon";
          PATH = "${nix}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
          NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        };
      };
    };
  };
}
