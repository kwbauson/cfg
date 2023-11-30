scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-11-30";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "c8c684491c5fe78a6481ab3537aa3542fa096c4e";
    hash = "sha256-NCZxMqKzMIqkrMihDtHVMQ0yfGfrPgENlIhPK3HerQ4=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
