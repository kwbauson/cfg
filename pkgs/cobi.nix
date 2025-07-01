scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ea5a7beb8bb5da1b0e1a9cf525591012e5a00bf2";
    hash = "sha256-pGD6f7i+j+bakzJKi1CedwFaX6Vtj1c0DT0rtnt/qHI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
