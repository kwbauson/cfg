scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "806bd3e1e260e5812595064918636ec5b13e5c72";
    hash = "sha256-ZHPdojKrj6aktlGB91TobC3xzToHjwPlqDUT5KxWeD0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
