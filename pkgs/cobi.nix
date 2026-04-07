scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2a47402a8ce9a7562b2ee6eb3002cc33757fb560";
    hash = "sha256-EYDmmD7VbsikWnRfzt+E/x9snu3Dl1YGT6AT9BpcvYw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
