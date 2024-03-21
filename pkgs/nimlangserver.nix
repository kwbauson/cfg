scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-03-21";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "41c03e4946940be78e411ae5cf9f4ba107968a22";
    hash = "sha256-Xm87IU5LwcTGL9IpyVbemZzuL0XWCT7RY6j+SCZ4SaA=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
