scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-12-11";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "cc2ef410548bab416304fada49c723bd264044c7";
    hash = "sha256-7sUJBjNMHqY94tZ+XfJfaWdD5HxPOAYkR4nSR1e7RiU=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
