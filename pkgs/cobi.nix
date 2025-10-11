scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "59b1c0e6efd0f1488af9e85a6511beacfd840a72";
    hash = "sha256-QJL040xqJUeX3+w5UK8Me3kjzHk3l8RL2PARCB/2ybY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
