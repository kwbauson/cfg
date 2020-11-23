pkgs: with pkgs; buildEnv {
  inherit name;
  paths =
    let
      nle = (import ../nix-local-env.nix { path = ../.; inherit pkgs; });
      pkg = nle.packages.nix-local-env;
    in
    [
      pkg
      (writeShellScriptBin "nle" ''exec ${pkg}/bin/nix-local-env "$@"'')
    ];
}
