scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-09";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "f9fe9324e4844ac95a6e4494ad0bb41d34403c48";
    hash = "sha256-o8tLGYZYAvgFBckcrt1gnc10noRN4kQaoDru4LFdOVo=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
