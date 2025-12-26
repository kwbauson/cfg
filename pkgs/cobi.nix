scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b3301a1a633180563201ffc19386efd5f87296bc";
    hash = "sha256-txo9d09fvZH1k4D9eQifPWSPo4Qdg9EqzrcikX4QTkI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
