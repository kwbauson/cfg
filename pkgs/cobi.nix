scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d8c4848d6cda2856bec1eaa977881bbc60896c9a";
    hash = "sha256-BjdhSD7Gj259oyAscKwoHcJmNBK13xDDgjXqjvks/5A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
