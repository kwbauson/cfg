scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "de5c27658b19608390cd9c2d7f28d16f6a8a72c0";
    hash = "sha256-xtE+7EKn0mhYzg/ROauSlDsiiFnU0Wvh2N63Gpm30Gw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
