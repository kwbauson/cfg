scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2dcd35cc7ca3d9bed7b83fe50ee27a5ee26e21ae";
    hash = "sha256-9kBGWaJWujy5R3vbWFNfc9olEW9Ne+3MNAdBIughhW8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
