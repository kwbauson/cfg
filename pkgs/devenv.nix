scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-02";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "e4019e17e9818cc3f107cef515d23d255e43e29a";
    hash = "sha256-UYbmL0db7+yQNpQ3nyW5077kmtB3fT/M0h/LhosODm4=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
