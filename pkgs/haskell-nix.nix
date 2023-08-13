scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-13";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "2861cdaffe4ec76415ecce6993357b7aa163899e";
    hash = "sha256-Jei5d7sJkU3cSDTEnsvVnBSxVOnBrFETwBUSvn6Von0=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
