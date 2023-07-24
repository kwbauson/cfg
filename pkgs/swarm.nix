scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-22";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "f9c22635b5160c0610683d55b387f7157f6ee8f5";
    hash = "sha256-n0EwdtpJPSItvf6e6h5t9lXGHuVyVG3KILPlUPGTreM=";
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
