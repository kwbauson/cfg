scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3153595ccc1623482f4369d3a04a2fcdb4623bf4";
    hash = "sha256-wfEg5+AJdjYPB9aWgbcN5pB4gXRvxBOZP/+8QYuIqos=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
