scope: with scope;
{
  build = let nixpkgs = pkgs; in
    { path, pkgs ? nixpkgs, source ? null }:
    import ./nix-local-env.nix { inherit pkgs path source; };
}
