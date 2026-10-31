scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-10-26";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "60182817ee048ac94b4c68ea76d5ef2e8aac730d";
    hash = "sha256-Y/JIHTnMlOabDfyaSBubWGLDIVGihLEUuoMhFvQKaDo=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
