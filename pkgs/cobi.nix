scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ba721a96f1f0a71602b7be8c34b5dff99b0425ca";
    hash = "sha256-SUcA/9d/6YYTruNdy3IR223vjqUZiVJExrSuiwh91+M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
