pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths =
    let
      nle = (import ../nix-local-env.nix { path = ../.; inherit pkgs; });
      pkg = nle.packages.nix-local-env;
    in
    [
      pkg
      (writeShellScriptBin "nle" ''exec ${exe pkg} "$@"'')
    ];
}
