scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-22";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "1763e54ba26f9268cbb76862848030fe9cebd9a3";
    hash = "sha256-/pGHjiMvsgOzHrOdEO2lwHM9heR8x1e/YMuCVlq/n60=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
