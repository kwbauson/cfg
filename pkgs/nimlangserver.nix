scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.0-unstable-2025-03-19";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "c9cf8ef3111cd607d3c04e8732172d23bd102d04";
    hash = "sha256-KApIzGknWDb7UJkzii9rGOING4G8D31zUoWvMH4iw4A=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
