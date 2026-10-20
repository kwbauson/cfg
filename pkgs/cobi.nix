scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "554937c5c717e101a03bc7213c725c3fadddaa13";
    hash = "sha256-2Lm5TY5lsvoGfzjDidvex+nstYMjAuz2rbSsCRUEIq0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
