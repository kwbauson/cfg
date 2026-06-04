scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3a09459667576f846dec9111aa0691d2990e48bb";
    hash = "sha256-zVUd/5ODa3qgatEgE9cM6fawW1QDrF67lTsedYZi9Bc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
