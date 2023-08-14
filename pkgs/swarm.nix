scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-13";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "00a1dde1593021d9ec1589d91032eeb3662782c7";
    hash = "sha256-ADvviR+Ym1984yY+MO4D0r0akaOdhOO3siE2ObfVlsQ=";
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
