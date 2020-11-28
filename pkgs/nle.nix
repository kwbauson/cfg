pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = [
    nixLocalEnv.pkgs.nix-local-env
    (alias "nle" nixLocalEnv.pkgs.nix-local-env)
  ];
}
