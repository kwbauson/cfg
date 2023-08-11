scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-11";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "2ae97270776e0ea43e665727d5b88bb4ec4d33c7";
    hash = "sha256-EHQ2RnPTadPfhnoo3z3eYRvQXr2jHiX44bnO+XcinkY=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
