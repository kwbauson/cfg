scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-11-02";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "2f6b57783cddf80d91b8828b9a29c248ccbbc5c7";
    hash = "sha256-XYoLYHQtYrlxUqKk4zO/f7xmgryySj2yrr1FYz3cwwY=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
