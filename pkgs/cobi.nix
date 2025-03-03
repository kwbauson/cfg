scope: with scope;
{
  src = inputs.jacobi-nix.outPath;
  pkgs = import inputs.jacobi-nix { inherit nixpkgs system; };
}
