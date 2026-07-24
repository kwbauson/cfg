scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "095c660863348be59cb3051cf117b9295df34806";
    hash = "sha256-hSaaUrWlBKZ8nFNDiNmHIMW4zOgI+p/HSwa7L78g+no=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
