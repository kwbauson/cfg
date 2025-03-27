scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.0-unstable-2025-03-26";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "018f5640dcc9badca5cb466facfee48b1350ca19";
    hash = "sha256-CbdlDcEkX/pPXEbIsSM6S9INeBCwgjx7NxonjUJAHrk=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
