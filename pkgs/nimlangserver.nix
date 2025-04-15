scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-14";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "90a131db78a20cc8ffd7b682b9e01fea56d925a7";
    hash = "sha256-Dc36jivRaQDu5BJUXL0wncW/MOHDxM7h/JMZvcr5f88=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
