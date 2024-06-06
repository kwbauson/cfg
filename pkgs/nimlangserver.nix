scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-05";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "09913281ed9c74f0114108e8cd0c30dfb0ba9c8c";
    hash = "sha256-EVTb6czLmTU7ak3PuNqiTPD2L31BnQHG0ewgFKGIPQ0=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
