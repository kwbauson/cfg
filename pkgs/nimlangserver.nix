scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-24";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "7e914ebc27f6f81f8e657610159a1b8c915dd8c9";
    hash = "sha256-IWljzFs31ryZjpE02taNeutNuuIJFDhI2JMGAsiBiBo=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
