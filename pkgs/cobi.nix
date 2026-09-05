scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9311f438abb6c7fdb1705f4c1b84cc31d71f0fb6";
    hash = "sha256-3SCv730ZduX7s+Yg5vMzRR0IG7bevIFg//E3ITAHjQ8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
