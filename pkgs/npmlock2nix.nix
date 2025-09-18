scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-17";
  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "4d9060afbaa5f57ee0b8ef11c7044ed287a7d302";
    hash = "sha256-qJc3ffjHVXUdZqytKcDK9XZ2b3BQ1RdYfZFuYgxbrn4=";
  };
  passthru.updateScript = unstableGitUpdater { };
})
