scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a9c3874cc07699d9c46c990532de5c1eca0547c6";
    hash = "sha256-1hV7+EqZQdFQXsqtcVaIkWs1HsR0kcmnnUNKgcI83cc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
