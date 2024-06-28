scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-27";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "fe0d9edff537f2dd653e011963c1b56ee95b9536";
    hash = "sha256-biBTX7X27RtFpQFPOOxdOFvT71m/AdrLhnZxEh+t9k8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
