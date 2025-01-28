scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a113f25e562006187c7010669fddb4a84b063d4e";
    hash = "sha256-a0ZBnx24/oH3pkUtG9HOV0DSRjwxaoqZq8vMKipL45A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
