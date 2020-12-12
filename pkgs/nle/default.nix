pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = let env = nle { path = ./.; }; in
    [ env (alias "nle" env.pkgs.nix-local-env) ];
} // {
  __functor = let nixpkgs = pkgs; in
    self: { path, pkgs ? nixpkgs }:
      import ./nix-local-env.nix { inherit pkgs path; };
}
