scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-29";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "843dabe7c29f49bba59de3dba0b63e724e747481";
    hash = "sha256-GrnnXPyras6u9O25HNX6uPDxQArmV8dugCDGkfdCFDQ=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
