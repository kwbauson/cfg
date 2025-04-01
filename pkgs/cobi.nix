scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d466b2d8fd69baa43293f3c56bf329ee31935e39";
    hash = "sha256-sSmvrwrYY1bubPTaDQKG1Un6TFE1ynY2cBSMCnh4j38=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
