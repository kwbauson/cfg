scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-24";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "2d67a229d78e0fce9dda1009a484eb752b9c0e99";
    hash = "sha256-DR4/N2qYneIwbi9nPFN69jCkGHv2hVXKv6uVB0ojbzQ=";
  };
  package =
    let
      haskell-nix-flake = (import inputs.flake-compat { inherit (pkgs.haskell-nix) src; }).defaultNix;
      haskell-nix = haskell-nix-flake.legacyPackages.${system}.haskell-nix;
      project = haskell-nix.project { src = attrs.src // { name = "swarm"; }; projectFileName = "stack.yaml"; };
    in
    project.swarm.components.exes.swarm;
  meta.skipCi = true;
  passthru.updateScript = unstableGitUpdater { };
})
