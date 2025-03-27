scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "83eb90f14b4c3343c7ed98d461e094087504f757";
    hash = "sha256-mwUbpSD/OxI3fwI8rGsjZAWv8KdE80X7heKWGHh+xjU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
