scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a3aaff4bf7a9ee8a05130ab2a5fab1d1cf8493d1";
    hash = "sha256-mnejItssqXIyxds/9sOExBvixO8bxwyfeGeiuFuLnm8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
