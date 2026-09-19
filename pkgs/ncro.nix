scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-09-15";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "2f28dcf17a62bed3cc4a9741914f9efb3ea363cb";
    hash = "sha256-s/vFy7F+iaHM3zW31fAR/LeTwZWiVKxiMzR941qgg4A=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
