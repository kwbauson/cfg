scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-24";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "e713da2ecd128c2c469c596a5f0fb8bef6af64cf";
    hash = "sha256-zk38CVEJtNkkDuEh/+F/IaK8CWLNWMxiJp6G3sfqS7g=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
