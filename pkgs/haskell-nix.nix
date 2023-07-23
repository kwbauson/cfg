scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-07-23";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "c7e8f3e506549575166898aec318a04442973f03";
    hash = "sha256-NyoXE8xEyuV7vzXuBbVVJTJhzUw6eSvQ/rfgrruXJ08=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
