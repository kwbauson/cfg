scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "30c791a5b10050b51a4b868eb62bfcd57c1cffb6";
    hash = "sha256-N9QMTtIZObAsaduN3uIJYAss4YkrDp3cKsh2t+A7jPQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
