scope: with scope;
let
  haskell-nix-flake = (import inputs.flake-compat { src = sources.haskell-nix; }).defaultNix;
  haskell-nix = haskell-nix-flake.legacyPackages.${system}.haskell-nix;
  project = haskell-nix.project {
    src = src // { name = "swarm"; };
    projectFileName = "stack.yaml";
  };
in
project.swarm.components.exes.swarm
