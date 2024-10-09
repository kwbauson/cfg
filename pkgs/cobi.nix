scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2d407561b3914b9fdda4db58862f6fe1be10960d";
    hash = "sha256-qACDdKoPdxJzgkMcY5IzTahQGPLSl8MiYzpr5EuiFaQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
