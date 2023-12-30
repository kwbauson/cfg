scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-12-29";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "0e0f215520ed3575a3dd769596c2ddb331b23144";
    hash = "sha256-tfRqZn6Ep0EumXRe9FD9bN/ERVEQFOjKq+lzUuyrOvY=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
