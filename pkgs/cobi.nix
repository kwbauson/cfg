scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1bc90a031d4adc0bae4f315a172bd34c32cba9ec";
    hash = "sha256-iHmiiGaBUwXsyIgmjmaCxSvE8DX026JFxkqZnXcHDOw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
