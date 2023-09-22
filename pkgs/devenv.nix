scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-22";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "1f21193496c515e55c556176e6aa13db9fdad1b4";
    hash = "sha256-VsbuaBJ7Hx3aqdPPRT2Gp+TmAvtJtcffQGChws9VHZM=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
