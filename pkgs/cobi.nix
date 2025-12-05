scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c12d8df98f37d788e47a305901566bad77ca69d6";
    hash = "sha256-eEuMIt4MGK5uSZ6cuFvm+i9+zn2dOI4/kIRb2EA73jk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
