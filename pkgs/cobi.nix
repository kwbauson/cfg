scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3cfddccef84a90ccc971acf14e0a2b00b8bf8333";
    hash = "sha256-1+bjRixT7e8W7eJ2arVPPah6Nx6NGepCTtrhdnASk8E=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
