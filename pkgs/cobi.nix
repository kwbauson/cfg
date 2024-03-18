scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3be2747a51588843bc3c26e83cfeb9fa2a135f7f";
    hash = "sha256-G4eUjq+hnZ1Spptb/alYEKi+jjklMndQA989pafFESI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
