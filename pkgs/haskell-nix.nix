scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-15";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "a411091b2709afa5a84384a5ddf15046b9cabec6";
    hash = "sha256-TroQTQuEz6rlCuXOk+DTCI3lQPbK1tAgSeOZq0DDt9I=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
