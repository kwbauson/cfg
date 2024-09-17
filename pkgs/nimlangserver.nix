scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-09-16";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "9bc31b4b531e96e1feb66c1ee32206a82caee39b";
    hash = "sha256-5s30XNfkUdclRQBV10mJWSUk6ksLQr/ZMhS7ekbI/Ew=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
