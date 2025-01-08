scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2025-01-08";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "d30f451cbf3f143ab2d6bb50a879b6b32fb8c052";
    hash = "sha256-AeWxnYPvA3NlYbXaIXApaVIWblATHGfKEjCOYH4+SPk=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
