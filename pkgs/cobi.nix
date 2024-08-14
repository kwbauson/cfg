scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f885b559497ab8d3d97ea74e0559a26791e6db2a";
    hash = "sha256-Cu7oRjsuG+L33XVyBBTW8gyIJJW1LZVYf7XQGt064ek=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
