scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-06";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "d6b6cec286e754869ad9767dbc8db686ed2b770f";
    hash = "sha256-9iHzyWIvBsGN55LbzjUgTMCAPH19cF5C9eCJk/sdprc=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
