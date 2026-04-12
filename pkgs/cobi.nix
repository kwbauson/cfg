scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "949c1fde9f72f0256b6233de3aa1b7d3ad3f0e3f";
    hash = "sha256-FEGMFUOK4qc0aeZoXxpWgSbeGJNXu9ExKxIXO6PW4dQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
