scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5edad94419ac3c16631ef9777876c2a6e89158ae";
    hash = "sha256-X5qO5O98Ejn6gHBrLKpxIRTUlbSINK/S3xfkRBX0izE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
