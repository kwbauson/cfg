scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9b9c6acec87ba54cc266b9fbcca087552287cf0d";
    hash = "sha256-vJ+sX8hWW9EthDI4dxAhpQp5Rf4skcnkI1kEYFURnCo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
