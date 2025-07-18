scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "708cdd6dfcc4f3f9d1fc83052a08c6dcd1c26fbc";
    hash = "sha256-UFreCoqiRBi091jaledOlfylqQO3Dr9E3v0syv8ZaQM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
