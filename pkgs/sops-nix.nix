scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-10-04";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "dcd241ba97088c22569d1573286e1b9daad340c0";
    hash = "sha256-nFxM+pKoZ8LJAEnUXARyCaOAloWgaW9kZQOSjWzKcTE=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
