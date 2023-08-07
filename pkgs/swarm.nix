scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-06";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "8aea6a24be62f742b0f64e66d63f4d79f4ad573b";
    hash = "sha256-ZKsllfPhLMlh4Ms+6qSGGXruUeDTzjLg3f0qPJV8zkA=";
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
