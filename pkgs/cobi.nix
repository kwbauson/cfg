scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8c652a0f8e18f2b7bcb1b8afd6d0ade612d22f4c";
    hash = "sha256-rvv9UhX+qy5qtpJXHLm76LHKYNqwOMdpDMiFaNX3G0M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
