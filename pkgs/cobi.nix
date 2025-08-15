scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4452346fec9fd8fabe54ef7a21e1c73d0af77397";
    hash = "sha256-IWOcLjna5hAyTEz6Z6YHPOPZ85O448iaTY69+RxlgZk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
