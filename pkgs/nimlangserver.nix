scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-07-29";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "7c6df11bd5b6d1a935eef5e98bef33caed5b64a3";
    hash = "sha256-jKpOOWOtfOFwQaS6nM9oYThh+ysIC5az5IVYZV+KMvM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
