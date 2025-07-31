scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cab42a3b62f0b12a43bad1bf8e8632b878c7e742";
    hash = "sha256-+Mn5VGCvDOs1PkNVLJZIKUpXJHTNEcGPtCkluu3BgpE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
