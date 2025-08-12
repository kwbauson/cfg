scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9862b23167e80bdc134aad7f7446436c235c4945";
    hash = "sha256-bIvRYP2eAS39a8DNezqUR0jXfCzq2FMDLeWohURgg3c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
