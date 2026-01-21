scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0fa40e09f3d6b7fe29811caef876444be9fa2a1a";
    hash = "sha256-0bOIxWMxu0o2TMoNwOglH+MXTUOQd+8F0oEKRIQK15o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
