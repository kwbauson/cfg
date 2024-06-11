scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6688c453781389f1dfdb7e04bf4b9637c8e1ff9b";
    hash = "sha256-JkJ7gKjKqZCOKekNJLjNd4PjkL2VtMgWW4KIGMMSv5c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
