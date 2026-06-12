scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-12";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "eb67df31a0d64e3361a5589c786e4af9a9cb8c1d";
    hash = "sha256-6DQAktdvTUNNRb8cNGndntsYER02rDbL8GQGJVnZ7Ps=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
