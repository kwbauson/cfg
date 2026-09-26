scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "37039dd4909223785271ac1f1b476b7da1b68677";
    hash = "sha256-YoZ/CciIVhqa5qDlS8HQ2iaRCCPPODmvstYgnT44SDk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
