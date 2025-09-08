scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dbeabc850ae8ddc17f0c7a5fe89b5fa3c9dfe9c3";
    hash = "sha256-JZRdl+JTyW4/fvrn315g0HicXAV2H/3qmcOEZHzPmCo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
