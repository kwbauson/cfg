scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d4ee9f0ea9a361a456a0c45ac2b6de19bdf18d70";
    hash = "sha256-XqwrT8wBZW2pgZBUJB88fmWIkHobV1oryOCiUoaXg9Y=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
