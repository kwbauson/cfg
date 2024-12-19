scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f3d113a10092f7ca894da4d8445af38685db5d96";
    hash = "sha256-EOIAZ+2nTAMUuaq6wWiDK36y8EEH2hEGHLm4AEYaPUg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
