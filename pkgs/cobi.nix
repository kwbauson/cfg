scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "77829728ba1a4be81d323ceb59842b6f8878e90c";
    hash = "sha256-qW64sAVWabF+g2y4MYexOFzlrJ9F7t/26IXUQLETc6U=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
