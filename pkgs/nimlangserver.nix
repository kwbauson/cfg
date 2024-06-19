scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-18";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "25194fa843a7770eb241f148dae4159594d93b78";
    hash = "sha256-JAncM1ePezZHv9/ijrPMfN0Dw8BnLhRyz/LvOfOtGPQ=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
