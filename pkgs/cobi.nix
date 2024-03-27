scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "537616f182d500dc12b8b3a751a188d3504354c5";
    hash = "sha256-uHOzxHrvrxP1DIZKvsYzCvHWb37cpLpNa2r21JZWLeg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
