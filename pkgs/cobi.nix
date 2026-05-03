scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8ff23bca31b0289b10f57a1a52d3de653ec3d3c7";
    hash = "sha256-puHfRQ0+GVjW8qU92cc9OGC094NMDNgOlMtOzCj+6zw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
