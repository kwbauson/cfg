scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-19";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "7dcf3063ae37c3f012a9c7f4de8561af4bd2a289";
    hash = "sha256-DqRqnGyEmmkB5sbvg5/n4Cyraaz84wwl86ZbpT2m+oA=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
