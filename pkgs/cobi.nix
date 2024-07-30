scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "58d8de0ae1e8fdf0ed6c49c2bf726a64a5340369";
    hash = "sha256-3UrJ+WWjUNblMgd46U/rgdxvS46mwIVA7b63GH6SxSs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
