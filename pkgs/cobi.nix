scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0fa103c1cb68ae93b03f9879ba273854fcc0a5ce";
    hash = "sha256-aJ+P756jW04M2lz7wWbNtifrRc0SolI2BvMYBIhXdss=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
