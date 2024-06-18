scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0cc3441b8c7b13a652f5e79eaeca4e90a981c541";
    hash = "sha256-zEoo+RvyvKhJ9dDEqoh9g5ayu0gui/RMVSER5JnAYQg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
