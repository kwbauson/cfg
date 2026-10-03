scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-09-30";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "14ebb0a4ba22358abe77ee4b3a3f793811e63573";
    hash = "sha256-Mxg043HH0/X15CulDQN+QhuwDTHjmPhJUgHdqB+XYqs=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
