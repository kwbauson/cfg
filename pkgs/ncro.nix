scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-23";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "9f499ccbe99e7de8f618dc3d83d6ba4bd14f4423";
    hash = "sha256-3+novBeeq0pyZ0PS5pUbG+rWG6NQYyF5EYdakxai5F4=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
