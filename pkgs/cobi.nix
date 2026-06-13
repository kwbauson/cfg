scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d3f1b97be28fc7ff52ffb5a464e53e2eb76e691d";
    hash = "sha256-LsWytPQOtTn2cgD5N3UsMjEbEk+N3WfU2RwgAZmQsIU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
