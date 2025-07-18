scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a6400ee02c081a5bfa1b3f1f3c131d302084a236";
    hash = "sha256-mtTznOLuaEi4G7eJpzJFXNHC/Q1ZHWV4zdYPaBvSTn4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
