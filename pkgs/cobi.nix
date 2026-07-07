scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "da9c2c0e5158135eb029c0a6543bed7e3cbec1cd";
    hash = "sha256-602OAcjVptisNUWRtsHvl7yv+L9wn98lAY3uwwikeFs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
