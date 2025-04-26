scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5a7cbdd8399da49b6b5aef239ed9a84687a6c9ab";
    hash = "sha256-in3fjl/yzQNy3shZWlDQ/jvsVupWzuzOX1nbZmJW9gk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
