scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c852af32a7a9fbfc4dbd16e1e0ea6bae93b0f3ca";
    hash = "sha256-EOeDu9Gzr57ybGU/U9lHcXdV0NuOCmxOVODOKPvUTQA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
