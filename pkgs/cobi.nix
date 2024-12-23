scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c7d6fb8e10f469fd091775bf64b89613e29af860";
    hash = "sha256-mGKKW/4ukbYQg4CutasCijKe5rDb/01kw/KDZsWBEds=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
