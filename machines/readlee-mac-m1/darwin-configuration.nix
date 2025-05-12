{ config, scope, machine-name, ... }: with scope;
{
  imports = [
    modules.ci-substituters
  ];

  _module.args.username = "benjamin";

  users.users._github-runner.home = mkForce "/private/var/lib/github-runners";
  services.github-runners = {
    ${machine-name} = {
      enable = true;
      replace = true;
      url = "https://github.com/kwbauson/cfg";
      tokenFile = "/etc/github-runner-kwbauson-cfg.token";
      extraLabels = [ "nix" system ];
      extraPackages = [ gh cachix ];
    };
    runner-benaduggan-nix-3 = {
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
