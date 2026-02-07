scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-02-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "73393aab7f22aecfde73b07cc020b30b6480b861";
    hash = "sha256-FJswfPPDGEZ5fL+xTmSs4f3P2BV72nOyi0YU+3968k4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
