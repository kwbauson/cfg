scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8713a501266fe994a90c3f0a876e4c844d7c4dfc";
    hash = "sha256-H8PlUXIEVqxupABQOToGMmChB2ttlTRyUuUsbOMcYz4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
