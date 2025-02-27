scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-02-27";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "f737bc0583b9f53d383337051787cd5cf735a5d3";
    hash = "sha256-qSwCZ0xDWQTIGVuNYAIX867GctvLHp3x37Q5EDfp24I=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
