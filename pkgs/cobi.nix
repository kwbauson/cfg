scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1b9f050ce02012e195c0ea82d9328705930958c9";
    hash = "sha256-Yfmy0HZCqFzLSPQWSNNGLg16D87UfpX348wP+Lip26k=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
