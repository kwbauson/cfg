scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c06758b558216c6db3e640e082e4da924fc30712";
    hash = "sha256-EjMFK8CPzceYq7AUvsGaoiiqWgWngaGIVS0xoo/rS1c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
