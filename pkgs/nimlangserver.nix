scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-09-20";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "c17fb97b2e73c34ff986342a22675c6c3e3ea432";
    hash = "sha256-PxFPwGkq93266qY+bH/ODfym+71DmQcHFXdBJ2EWbeo=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
