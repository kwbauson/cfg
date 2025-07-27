scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "14693aab90322f3364f589b9e6de68e4022160cc";
    hash = "sha256-B/j48nhLKfPj3bC2XZTaQZwYPzfdkH/L4x/rWHsAdoQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
