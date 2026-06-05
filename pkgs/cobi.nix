scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2f5841961d008d6c0feab18359f5a4eacccb9d86";
    hash = "sha256-NmphbcFoQg5BuhfW8HG1xBPdCaZIrZBi2CpXcuWQuDY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
