scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1458ac015aaa61dbb182d03c7804bc5e3c58184d";
    hash = "sha256-QFDCsV0kQzQO0thDIGxe8BN0IfBuPsgkHmoDUXKf7UI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
