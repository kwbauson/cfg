scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-12-21";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "5839910121adcceb2ec61b76d949de354f5b6c39";
    hash = "sha256-/eQx0CWSbrDBvEMO5QxyZ81pWraPzudTOJjG+Rjn3Ls=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
