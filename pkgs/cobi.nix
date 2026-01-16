scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bcc5d641075841528fba0220043040b5372fec77";
    hash = "sha256-JhFVVlURjxlq2DukqHtRS/rIX5Ap0v2jpnVY3h3eZhY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
