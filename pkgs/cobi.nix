scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ddb85e918b441b539f6f2e56511d94b11e0145e7";
    hash = "sha256-gIMGUKlB8CZfMf/dRPQbzqfF2rAanhFVQP/Heu0cpzI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
