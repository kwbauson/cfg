{ config, scope, ... }: with scope;
let
  github-runners-fork = fetchTree {
    type = "github";
    owner = "DavHau";
    repo = "nix-darwin";
    ref = "github-runners";
    narHash = "sha256-z9PpdTZRRaAXM6eFznIgbNCRp9jQoIAQ67k0YDxvn/A=";
  };
in
{
  imports = [ "${github-runners-fork}/modules/services/github-runners" ];
  _module.args.username = "benjamin";

  services.github-runners = mapAttrs' (n: nameValuePair "runner-${n}") {
    kwbauson-cfg = {
      url = "https://github.com/kwbauson/cfg";
      tokenFile = "/etc/github-runner.token";
      extraLabels = [ "nix" ];
      extraPackages = [ nix gh ];
    };
  };
  launchd.daemons = forAttrValues config.services.github-runners (const { path = [ coreutils ]; });
}
