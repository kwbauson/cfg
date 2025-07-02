scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "48a658af2d75287a8e863dc13047851e4cf7de60";
    hash = "sha256-/JUwlV2wr8GNNQy109/NKJ9GmGigxjlk4//oKNM2F2Y=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
