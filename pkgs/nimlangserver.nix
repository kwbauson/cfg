scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-30";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "bde4351ca4b4258d1cf6fdea000f55ea2b94330b";
    hash = "sha256-xtGkEstrToAJafIbhFXWO6AnJSJZKwe8mMcfvi0mv+0=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
