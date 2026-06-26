scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-24";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "13153c506ae2e5ea0d072f1d0af0d923aefdf2e8";
    hash = "sha256-ftzqz/MsXiCsbX2Mwh73e4x4jzI0/h2uwDHPT3kmVl0=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
