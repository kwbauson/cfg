scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-10-11";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "aefb4edbcf598ab64ccc5971f750dc378672fe8b";
    hash = "sha256-9atvu5AjW0ZdxBiPbNY7Y+gNSTTP16pD6GgUhwfOYWM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
