scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-11-06";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "611c65644b019292798b7bdd663f8de6a3d3f4c2";
    hash = "sha256-jEQRPUfeX0nQogBw0OoJ1aqgigJDv2pqUA1JRLPbafk=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
