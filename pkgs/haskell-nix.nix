scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-14";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "71f026dc5e42931c7d517ee30e79292670c3ac34";
    hash = "sha256-SpeS/lPy5pxCszTQyGf8WozKEWIA4xGrHFtr/TguZjU=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
