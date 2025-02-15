scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "925f48b78847844a877055f56454f625b3829b4e";
    hash = "sha256-XGcxRMamkaA/2Y9Kufq7Zjogx14sQhxsfnq6pWegdNY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
