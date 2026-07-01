scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-30";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "6a20f496c472a31c0cc5c8935893844267f82c1d";
    hash = "sha256-x6AIpkQI2Vzz0xZRxAjtzItmPlao7O198EH+hs7Zz0E=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
