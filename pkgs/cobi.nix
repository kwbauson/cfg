scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1acf062a1d6d7d263280016bb11afc6c30182232";
    hash = "sha256-DMhakKa/I9h6x9klxkzXu0Rl9JNdsq6sj+IGo1vB4W4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
