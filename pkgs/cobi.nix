scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ebd301a2f33da9980751b6efe137d586c00bbfca";
    hash = "sha256-mCPinoTOxhJRol6MWl44un2ACJe6Xf9tS1WTfSmtFIw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
