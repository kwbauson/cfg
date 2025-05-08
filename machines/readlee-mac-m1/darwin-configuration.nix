{ config, scope, machine-name, ... }: with scope;
{
  _module.args.username = "benjamin";

  nix.settings.extra-substituters = [
    "https://benaduggan.cachix.org"
    "https://devenv.cachix.org"
    "https://jacobi.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "benaduggan.cachix.org-1:BY2tmi++VqJD6My4kB/dXGfxT7nJqrOtRVNn9UhgrHE="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "jacobi.cachix.org-1:JJghCz+ZD2hc9BHO94myjCzf4wS3DeBLKHOz3jCukMU="
  ];

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
