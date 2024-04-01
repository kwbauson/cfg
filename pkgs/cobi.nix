scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5f633bb6d76db93ae5338338cbfba391e875ea77";
    hash = "sha256-g7MrRIVdCysk2vzRFdYiLkxvUjTsDK4DWuYBRCIkClU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
