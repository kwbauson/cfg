scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-28";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "71bc09671514648efc9c6ac45cc601b7f421f2b7";
    hash = "sha256-eOZrsFVG85cAiGZcpKmCz1eIV34cUYQXboPr3cw+jIY=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
