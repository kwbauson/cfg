scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-05";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "c69d76edf3c4547c363bdb2bc387a7fa773e3b12";
    hash = "sha256-siW1rzenZFAFYOgkvBaNpKCRruP7tTfrGU0HkoTjpgs=";
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
