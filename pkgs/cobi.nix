scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5fe6257a76c8da51b242b7dea2796d316247f817";
    hash = "sha256-2bb6lRDHKPun8kQwTx6/qSCqadZ6wBNZVehTwRQr6rY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
