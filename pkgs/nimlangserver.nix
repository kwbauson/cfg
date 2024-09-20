scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-09-19";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "78bc6466329b1fe6dbd864656ef6165dee18140d";
    hash = "sha256-s+uxoL2HBgIn3fzwRBPQ2ScI3NaAxAvdMkR8Bb2ChV0=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
