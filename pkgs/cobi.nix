scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "aa815dc96b478c317946fc9e738058d0883eeb95";
    hash = "sha256-A7HC4eT/rZDEvh9rx+rQ6tsV4chtGptzc90C1YFL/9I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
