scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4fc7c4991badbfc776c100064ccc7aec7cf79e33";
    hash = "sha256-QE8xflptNecuNai2yao7YALhgMDwzx3xeC01XMsSWBM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
