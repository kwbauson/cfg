scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0ac33d7f7d1490146d08cb89399ce87c9db595f6";
    hash = "sha256-sses5IRi7w63BjXIw7pOe8NNt1lIrkP+3fE4qoFXlmE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
