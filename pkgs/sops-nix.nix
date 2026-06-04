scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-06-04";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "9ed65852b6257fbeae4355bc24ecfea307ca759a";
    hash = "sha256-Gq8KNx5A7hBB3uGJaj6eQfLDIz5YdLu92gqBcvHvoUo=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
