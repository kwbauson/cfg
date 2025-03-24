scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4676c8528999c8924a834087fc79f3994ae30cfe";
    hash = "sha256-cEgwU/TidvGe9LIIlzdkr12NhXk1Yd7mVo+kU/CQYr8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
