scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8effb1503622ae0e3561e97ec83f8b1e606beb83";
    hash = "sha256-bCfnCEJRK63D4gv9y2rhsaPjGJqKYvWmAEVieClloA0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
