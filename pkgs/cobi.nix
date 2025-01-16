scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "aed4fe86ca42ae64c0f40d64540b95b415239ebc";
    hash = "sha256-tG1Ql5r8kcKUp/eGkWkQmJiJtN1pmj4FJpoTE/ljrk0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
