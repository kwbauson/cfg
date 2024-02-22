{ scope, ... }: with scope;
{
  _module.args.username = "benjamin";

  services.github-runners = mapAttrs' (n: value: nameValuePair "runner-${n}" (value // { replace = true; })) {
    kwbauson-cfg = {
      url = "https://github.com/kwbauson/cfg";
      tokenFile = "/etc/github-runner-kwbauson-cfg.token";
      extraLabels = [ "nix" ];
      extraPackages = [ gh cachix ];
    };
    benaduggan-nix = {
      url = "https://github.com/benaduggan/nix";
      tokenFile = "/etc/github-runner-benaduggan-nix.token";
    };
  };
}
