scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "70cdcdc0a8de287a523ac137364dcc1d0f7e11cf";
    hash = "sha256-/fFwVwYWu4+cTs1ra3eEN5SUf4jfB2dQWoLEs7Smn3c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
