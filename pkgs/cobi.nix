scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "17d9df250fd34b1fef96f0c0a05c965e2975e804";
    hash = "sha256-4iNymA3vyR6BWiifJ+lmf7YHydYP4r3dxqo/Tia12gw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
