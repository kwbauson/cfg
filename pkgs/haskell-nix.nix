scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-09";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "f7b7060b4f1f750395a37820e097c06f83b12c23";
    hash = "sha256-vY02hc1qZ21gHBD0GZiR8EcnpI9UrNCX/G5A41kaB8U=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
