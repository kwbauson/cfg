scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9bf5b619d4d0780bb925fff4f4d8dc3f44ab2f86";
    hash = "sha256-MJV9JON2vkfOd0uOHY3usEm6zekKFzr4oXmCvkRH3Yk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
