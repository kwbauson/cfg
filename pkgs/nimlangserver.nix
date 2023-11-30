scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-11-20";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "c28a4b52f0011d6cd4f1b8ffd0c5c53766bd13f0";
    hash = "sha256-vIaTN+duQpDmoMDrelJmK5Wno3M9p3WAfbsDk+wTQ1k=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
