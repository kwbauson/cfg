scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "565db16a34a0e83305a2cfa48b8b5c50edbecff1";
    hash = "sha256-89Jn8jtlCSFxEyGTBD3rFQA2gAeTKMe9EnW+wJdvHfs=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
