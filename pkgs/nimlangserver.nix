scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.12.0-unstable-2025-05-05";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "610adbf680dc927450de9117d7438a9ed27f0c1d";
    hash = "sha256-BYYgnjkxlXNsfwU33a9uRYytVNfHznXHy/Gf0bUcUv8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
