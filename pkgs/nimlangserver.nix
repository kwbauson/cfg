scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-22";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "fb725fe9de66979412341a97d6103386e003e0b6";
    hash = "sha256-UTHMozvSlOWw5wj4y5BLFF1iYMeMxfPQcPwp26r0yFQ=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
