{ config, scope, ... }: with scope;
{
  imports = [
    modules.ci-server
  ];

  machine.username = "benjamin";
  machine.tailscale-ip = "100.118.226.25";
  machine.public-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvKJG6bwQ4M3LooY17neqDueOZyVfxLfgUBMcv39iqv benjamin@m1";
  nixpkgs.hostPlatform = mkDefault "aarch64-darwin";

  users.users._github-runner.home = mkForce "/private/var/lib/github-runners";
  secrets.github-runner-token.owner = "_github-runner";
  services.github-runners = mapAttrValues (c: c // { nodeRuntimes = [ "node24" ]; }) {
    runner-benaduggan-nix-4 = {
      enable = true;
      replace = true;
      url = "https://github.com/benaduggan/nix";
      extraLabels = [ "nix" ];
      tokenFile = "/etc/github-runner-benaduggan-nix.token";
      extraPackages = [ gh cachix ];
    };
    runner-magic-nix = {
      enable = true;
      replace = true;
      url = "https://github.com/MagicSchoolAi/MagicSchoolAi";
      extraLabels = [ "nix" ];
      tokenFile = "/etc/github-runner-magic-nix.token";
      extraPackages = [ gh cachix ];
    };
  };
  launchd.daemons = forAttrs' config.services.github-runners (name: _: nameValuePair "github-runner-${name}" {
    path = mkBefore [ "/usr/bin" "/bin" ];
  });
  ids.gids.nixbld = 30000;
}
