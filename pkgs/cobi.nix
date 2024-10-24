scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3f5e8c3545416635ac6262f319f6a9111a3f431c";
    hash = "sha256-gr4C+G9j5ibmfeJmohZRLmG+SPk2OBKu8mIL2Q2HPrQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
