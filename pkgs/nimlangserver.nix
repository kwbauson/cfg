scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-26";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "601ac2a8ce210e04975794b92c3a0af082db4198";
    hash = "sha256-+svLhGoiOjaS9KzAUJszmqymi4hfWHOoqg6lDoay5AQ=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
