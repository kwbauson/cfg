{ config, scope, ... }: with scope;
let
  github-runners-fork = fetchTree {
    type = "github";
    owner = "DavHau";
    repo = "nix-darwin";
    ref = "github-runners";
    narHash = "sha256-z9PpdTZRRaAXM6eFznIgbNCRp9jQoIAQ67k0YDxvn/A=";
  };
  readlee-runner-defaults = {
    url = "https://github.com/paper-co/readlee";
    extraLabels = [ "nix" "readlee" ];
    extraPackages = [
      (writeBashBin "run-job-script" ''
        export PATH="$PATH":/usr/bin:/usr/sbin:/bin:/sbin
        ${bash}/bin/bash github-workdir/job-script.sh
      '')
    ];
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
      extraPackages = [ gh cachix ];
    };
    # benaduggan-nix = {
    #   url = "https://github.com/benaduggan/nix";
    #   tokenFile = "/etc/github-runner-benaduggan-nix.token";
    # };
    readlee-arm64 = readlee-runner-defaults // {
      tokenFile = "/etc/github-runner-readlee-arm64.token";
    };
    readlee-x64 = readlee-runner-defaults // {
      package = pkgsx86_64Darwin.github-runner;
      tokenFile = "/etc/github-runner-readlee-x64.token";
    };
  };
  launchd.daemons = forAttrValues config.services.github-runners (cfg: {
    # daemon path fixes copied from the nixos module
    path = [
      bash
      coreutils
      git
      gnutar
      gzip
    ] ++ [
      (
        # allow x64 runners
        if cfg.package != pkgsx86_64Darwin.github-runner
        then config.nix.package
        else pkgsx86_64Darwin.nix
      )
    ] ++ cfg.extraPackages;
  });
}
