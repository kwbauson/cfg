pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = let pkg = nixLocalEnv.packages.nix-local-env; in
    [ pkg (writeShellScriptBin "nle" ''exec ${exe pkg} "$@"'') ];
}
