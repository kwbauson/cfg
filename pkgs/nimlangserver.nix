scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-25";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "fdcd323034067ed4ad2a86f1646f54edb28b1027";
    hash = "sha256-OhvP7DgCMqiY/LzMkNxeqaMpcg5q16TsV7Uzcwu5gPo=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
