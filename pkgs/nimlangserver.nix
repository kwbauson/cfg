scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-28";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "c369c2bdaf710009755d02d12d92b0cae1efb9d1";
    hash = "sha256-Qnojbo/TWQmMTwHp173Vr9MXphKhy0jCl4MdmqnxFRA=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
