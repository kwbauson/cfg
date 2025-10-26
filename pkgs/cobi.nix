scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7ab0d15726c487c5f7774fbdccaa4cce1c49035e";
    hash = "sha256-pmQKF2eKevKodQssdX7BJyAjD8q8Qt+S4dayx3olc5g=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
