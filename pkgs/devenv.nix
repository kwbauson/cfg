scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-03";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "0e68853bb27981a4ffd7a7225b59ed84f7180fc7";
    hash = "sha256-9Hr8onWtvLk5A8vCEkaE9kxA0D7PR62povFokM1oL5Q=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
