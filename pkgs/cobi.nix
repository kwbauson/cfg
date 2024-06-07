scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8605f076425324ec72624291e912b271a7ec1430";
    hash = "sha256-Frs+a/GHYM9mqPuop8TcGAQZ1U/zdqBbJdPaq2FVles=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
