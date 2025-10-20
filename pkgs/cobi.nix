scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ee58e7dd5c44e43641dcd21a07e3c581b422dc53";
    hash = "sha256-bNR7mIreSvZsek1ZhKm2gfbM1xNfxZf40wFoOgkO8M4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
