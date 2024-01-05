scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-05";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "36b9257a8d4026992ddd2e4f2167ed66cd39c838";
    hash = "sha256-6QB+aW9FnlLprjtp1CjaHaF/3iOn2b6rYYsdFtITJSE=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
