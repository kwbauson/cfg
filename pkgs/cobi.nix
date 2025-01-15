scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b61a7f310c2e7593c072ceacea3fb0d81f76659f";
    hash = "sha256-nfxIwmwVB7QZqxO/e4cLyO3aasrxrpqo+0nK/9d3skE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
