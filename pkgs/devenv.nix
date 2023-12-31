scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-30";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "7354096fc026f79645fdac73e9aeea71a09412c3";
    hash = "sha256-GgjYWkkHQ8pUBwXX++ah+4d07DqOeCDaaQL6Ab86C50=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
