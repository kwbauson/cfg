scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cc1bf2e80a4bf4db9d3697bd40002ff38735aa31";
    hash = "sha256-jQXalgDelZ4Gfr+/FeMkErW8VzRhvxJM0egTtKjIN/Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
