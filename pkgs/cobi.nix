scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "84da317e565d47fa1b39dffe1a661f2b5cebfd50";
    hash = "sha256-Vx18TrOwUUxck6ruXQAe4CJ4dSZ3U1CMRIpimVwADOM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
