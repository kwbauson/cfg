scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-17";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "dd16805e603c32f0c02fc443d334460a060b322e";
    hash = "sha256-at78FGA5pT4eNuDv0RAXXYF4yYYIIyK6EhLSAdaBlsY=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
