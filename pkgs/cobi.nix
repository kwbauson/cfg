scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ca645e44e071653a9d929afbc881db5d82f0aa31";
    hash = "sha256-Bop7qTgBeFj38za2PMqEhscYACVHdzAtS4dyyZZUeC4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
