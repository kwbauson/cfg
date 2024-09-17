scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-09-17";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "859019efb6cab8bd4d8f94cfd914f587c9a6387a";
    hash = "sha256-0RYuOPAMkITHArih6uXEetLD9iwDtlWiCreW/WvbfzM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
