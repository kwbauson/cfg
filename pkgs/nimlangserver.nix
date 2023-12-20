scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-12-19";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "61a13ca797c1051baab5d32fd5cdffeabfffdffc";
    hash = "sha256-LY19Bjy25cJ8yC6li3WlPlP7dKAiwGalx6ihsQ2s2LE=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
