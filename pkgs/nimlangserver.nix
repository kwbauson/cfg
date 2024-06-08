scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-07";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "be28878b37894ef67f0682c1074e973a6ca63fef";
    hash = "sha256-Qi3skxrBVQAsEmu9OjHg3TmxfSOyCdB/w4sH0Q7Wx3Q=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
