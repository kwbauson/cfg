scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-11-26";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "6dc8f953a0fea52ca36d9e11387eb235f9987492";
    hash = "sha256-/GfBBuzvXaig8wzanDsqyHyYuY50dVF4FeGVJV/DK8Y=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
