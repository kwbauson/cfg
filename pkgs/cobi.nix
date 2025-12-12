scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4f5e6098021cb1239efd152da8da1a48619e2acf";
    hash = "sha256-QkvAtxxocTbXmdjIz6a5bkNicXitNxWD0l6xczo2yvc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
