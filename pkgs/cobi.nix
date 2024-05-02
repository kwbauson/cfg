scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1e15b860236053d8e35a8044cf4ae18aea5d920a";
    hash = "sha256-npuiscuglo/BWwYB0JrDpPGqX1PdcjFR6800zSLrjSY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
