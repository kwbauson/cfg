scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-08";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "feb426a2260e407fc3a2875e3d0d47019bc1b6d2";
    hash = "sha256-VKH1FzsYwh28eKa2i/4+hyv2UWRTffKArbEmol8vU44=";
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
