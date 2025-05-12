scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "955536b4de3416731688416886d0197d819a1ddc";
    hash = "sha256-vxgsU1sNDjuW99txhABz8x0gLyXUPkd7UBH9HN1mXNQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
