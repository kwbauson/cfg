scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-02";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "a998b9833a22c97a36774834780834f1c62da63e";
    hash = "sha256-ns+jlx/r0OoARIeZjXHAA/jJjPUdpCBVAQ8JzUDX9RE=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
