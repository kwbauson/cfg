scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-12-30";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "f05b4198ddc41ad675c4f7803bc6769b8f470e4d";
    hash = "sha256-hmsunoh0P/OeUiEFfZeSlKTJPIsfJOJAJe+Q5Ib5zJk=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
