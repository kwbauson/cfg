scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-30";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "9f231aef9cb9e1ce8d892a69d3b8be2d33497967";
    hash = "sha256-ON8IV/K+GAEeVQi2+KfP5IQS3hzfptF40ggcF3Nz9jE=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
