scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e76e93090753226f59c1e2d6dc7c572c13a546d5";
    hash = "sha256-Atul7YJiL1bBttf+pIezUxVc4EGeKLRp+jCDtzna95A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
