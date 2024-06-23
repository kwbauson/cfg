scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c9f0ea95ec958123888dfc00fd31bab18dacc65b";
    hash = "sha256-2Hwc7vBTJJ7WiY4MePSnL7cOZXD8m7DSFpVNt4/FrWM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
