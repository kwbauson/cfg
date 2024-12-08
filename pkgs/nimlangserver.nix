scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-11-30";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "cf85884efd59f5228d79640833b0c5b65d97579f";
    hash = "sha256-Sg+An29siEkQHZqPMywS3thAKdp/GCbqkq5obdXJgxo=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
