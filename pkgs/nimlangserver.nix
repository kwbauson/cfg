scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-22";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "38adf69dd78f59f9b93ca246e49b9107477b94f3";
    hash = "sha256-3G/6bHwDCDW0ryBSDVP0R6NsAgqi8NHGZfRzJCDT3HE=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
