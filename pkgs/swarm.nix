scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-12";
  src = fetchFromGitHub {
    owner = "swarm-game";
    repo = pname;
    rev = "f743c90027e75b0ed8424395c896d63460d242b5";
    hash = "sha256-km36dhgPNWGsEzcSboomo9Mp1ZZZFlWX2WLoo2BigbQ=";
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
