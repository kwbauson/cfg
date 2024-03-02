scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-01";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "f0319af4f966fb8bc25c6429f4f2e097e79116c2";
    hash = "sha256-jkK99RiSt5YfLWj3kAQoB8OB3idxLTdT9kfo/wILbjw=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
