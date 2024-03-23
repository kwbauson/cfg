scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "98d83ee15cb082e22012efd4cd909253b1eed0eb";
    hash = "sha256-K/SFuNHRCLVkg3U8wy1NcryK/D2PBxWan44y1k36ShI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
