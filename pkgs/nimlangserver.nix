scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-10-31";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "238e968888d438c1b346c2533fb9082bffa4c9ff";
    hash = "sha256-7M6VzhI8BJ2Z70KJOeHxb/oclYCG4Ka4v37Swq66ddE=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
