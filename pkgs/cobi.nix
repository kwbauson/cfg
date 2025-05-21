scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5f19809f95e7a8e646a1493d2dc6f1450a528c3f";
    hash = "sha256-y7oCEwuCF4is4sIoM7ggQeBvwnoqY4YfANtz2w0Yl2E=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
