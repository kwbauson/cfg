scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "32af1075a51c17b80b5e17df66812a51d1c57e17";
    hash = "sha256-k5VCny4RidozSEIyfoe9bEPDNgYM0PNd0ksgYNroPkw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
