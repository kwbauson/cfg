scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-29";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "8b492b25e30fd228cca6a703b28af9a013a6a85e";
    hash = "sha256-yYdmYOzP6cBIIAahyYjFpVE0cLEblaOHGOVyXXGdoB8=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
