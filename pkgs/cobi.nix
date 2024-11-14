scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "333add65ad458899d125a0757874498d595473bc";
    hash = "sha256-83bsKvH+WubXZ+vf3P4DSNUi3xGSfOcRL9v59YMCfEw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
