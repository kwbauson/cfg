scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "25b070083ead9ae36984be27d35249fc885ef23d";
    hash = "sha256-EIcDdDHpbDMcgOKWreWTAlI8IsR9ARZ3PWRD3Be1sNA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
