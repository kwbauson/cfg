scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3597d2d512a88ab111e616f7a2abb9859cd50a3b";
    hash = "sha256-/oh14ub4DbpR+oMegsL/3D2alUv50npbcBKir//rLmk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
