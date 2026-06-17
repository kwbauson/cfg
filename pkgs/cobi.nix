scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "963ba45bb8290dcf51ff540117aa8ae8052682c5";
    hash = "sha256-kWZuOr4ZlFlJUmD57wbpBl23T/lAf3N96n0lQIzniOA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
