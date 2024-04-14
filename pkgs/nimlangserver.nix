scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-04-09";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "6d250f8071e1e02d15ddb6fa75e4530d137b414f";
    hash = "sha256-DLTDLUDv+PhuWVMmaKUwZcp1mILEMVKYqdwm6YwXYwI=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
