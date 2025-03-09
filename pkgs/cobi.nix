scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8e97b298748a24238371d578b047f32dc28bacb3";
    hash = "sha256-dDAAYFk2S8KqDQ0xMS1EeRAnbPK2DhhD22KTIdPfZuA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
