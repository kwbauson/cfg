scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-15";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "0179fa61b6b298b0976de9564c2f9fab27d2b526";
    hash = "sha256-xmgUhQ7Wno363QAdPHmPQ7mrWIH1jRH2ohWC/L7+Ip0=";
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
