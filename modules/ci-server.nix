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
    settings.enable_compression = true;
  };

  services.ncro.settings.upstreams = [
    {
      url = "https://benaduggan.cachix.org";
      public_key = "benaduggan.cachix.org-1:BY2tmi++VqJD6My4kB/dXGfxT7nJqrOtRVNn9UhgrHE=";
    }
    {
      url = "https://cache.g7c.us";
      public_key = "cache.g7c.us:dSWpE2B5zK/Fahd7npIQWM4izRnVL+a4LiCAnrjdoFY=";
    }
    {
      url = "https://devenv.cachix.org";
      public_key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    }
  ];
}
