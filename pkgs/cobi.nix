scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bb541da0233d0d8bec1d738d9b41ff352b283038";
    hash = "sha256-o3t7xfQdv/m5vB68V5M4XjF36rZ7veUTrEaD3YP4gbU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
