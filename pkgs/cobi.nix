scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0dc5ca6cc46a2214395a3e0b6e39096a7a3ca91c";
    hash = "sha256-TK2J8jt4c8GihayID4c4O/ay2zQg5cED2Px2vHWu7H4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
