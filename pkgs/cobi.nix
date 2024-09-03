scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4ebeda0afda256e059148496851455ca8c6045d2";
    hash = "sha256-XjAobsMrj6l/z/m36Gv0SlPzVIFwxzhOX4uTGHl2cBs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
