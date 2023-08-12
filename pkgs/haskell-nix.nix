scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-12";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "f3caec893c721415f9719b95eaa4e289a29eee6f";
    hash = "sha256-8gqS3fv82fHibbPQTEwT6BxaKBqnxLR0y2kb3KvoSVU=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
