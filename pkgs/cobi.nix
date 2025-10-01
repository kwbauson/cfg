scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "eb8029a79f707583fe6e34b21011a7e94801954e";
    hash = "sha256-Ahborjq8YmqpVwI6LosSoIw1DyVlek4xHTne7dCqwSw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
