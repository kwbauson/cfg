{ config, scope, ... }: with scope;
{
  services.github-runners.${machine.name} = {
    enable = true;
    replace = true;
    extraLabels = [ "nix" system ];
    extraPackages = [ gh cachix ];
    tokenFile = config.secrets.github-runner-token.path;
    url = "https://github.com/kwbauson/cfg";
  };

  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.secrets.harmonia-sign-key.path ];
    settings.bind = "${machine.tailscale.ip}:5000";
  };
}
