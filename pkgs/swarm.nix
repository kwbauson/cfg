scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-01";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "e8ea33927b319587232d19903db8bb3ca95c2a56";
    hash = "sha256-Nb6qjL4a6FBByzYAi+VR84xhNQiMetdMALj6x2yHzWU=";
  };
  package =
    let
      haskell-nix-flake = (import inputs.flake-compat { inherit (pkgs.haskell-nix) src; }).defaultNix;
      haskell-nix = haskell-nix-flake.legacyPackages.${system}.haskell-nix;
      project = haskell-nix.project { src = attrs.src // { name = "swarm"; }; projectFileName = "stack.yaml"; };
    in
    project.swarm.components.exes.swarm;
  meta.skipBuild = true;
  passthru.updateScript = unstableGitUpdater { };
})
