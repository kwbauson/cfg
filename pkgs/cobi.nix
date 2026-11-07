scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c10b3c6b0883441231d1bcd243ecd35a80d963f8";
    hash = "sha256-+2iGm3iRh1f6+sJF6BKofhySwBFB4vyeVmLvbDjrzfk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
