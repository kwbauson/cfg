scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a8d3d2f8e4685b28c3e4ac8f952edd933749cada";
    hash = "sha256-y597jdg9SM3JNohB0JHgaIBL+T5QBDadnauCqpkIxGk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
