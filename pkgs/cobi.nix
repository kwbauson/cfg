scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ca217a9a6ec2d0114be693c28d39fa1de1518bd0";
    hash = "sha256-vJizyWZHBwXpiwuE/nFF/R7JzpVyNJuGsNwg6s7u7VI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
