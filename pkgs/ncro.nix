scope: with scope;
importPackage {
  inherit pname;
  version = "2.0.3-unstable-2026-05-30";
  src = fetchFromGitHub {
    owner = "feel-co";
    repo = pname;
    rev = "2486600d8e7dfb1c851fd6616243f36daf30e945";
    hash = "sha256-TNVhADu3fY7hklHGtwcUi5rQWW5wY6mJl9wBngl7/MQ=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
}
