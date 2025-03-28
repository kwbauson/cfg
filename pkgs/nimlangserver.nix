scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-03-27";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "64b093616ebcd2b37b6e2b1a213796c98c8cbdf0";
    hash = "sha256-xeSfg3AMnvMhsESrRyn/Mm+LubLF320lWPfmTjA3rFE=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
