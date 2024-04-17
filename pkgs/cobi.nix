scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2190472937674abd3c04c5723262a62c5e722157";
    hash = "sha256-tTSrO2hFNvR0YRMXbMkORFefHfbkMXtoFJrQAXei9xo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
