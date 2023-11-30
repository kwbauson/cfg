scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-30";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "b57cc04435fbe6bc91ac343147986cafa2d45db7";
    hash = "sha256-VpKioSS2lL4//Yk9QHNre865VpwOBmIH7XPdUVe0O4I=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
