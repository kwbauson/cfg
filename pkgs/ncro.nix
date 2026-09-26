scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-09-21";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "bb4fb8329e30dc294b2298618ba96379860dfd4d";
    hash = "sha256-o5qPU/QPxcAmeVwFydXqEkn1HI6TbPgkHpecXyme6Bs=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
