{ scope, ... }: with scope;
{
  _module.args.username = "benjamin";

  services.github-runners = {
    runner-kwbauson-cfg = {
      enable = true;
      replace = true;
      url = "https://github.com/kwbauson/cfg";
      tokenFile = "/etc/github-runner-kwbauson-cfg.token";
      extraLabels = [ "nix" ];
      extraPackages = [ gh cachix ];
    };
    runner-benaduggan-nix = {
      enable = false;
      replace = true;
      url = "https://github.com/benaduggan/nix";
      tokenFile = "/etc/github-runner-benaduggan-nix.token";
    };
  };
}
