scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5dd52f3eee8377f9ac34f0e98ada7b78ee2898aa";
    hash = "sha256-NNBAHt29gkzUbTV9PG7+fBxXbS2T103hbcIS4AIZ/W4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
