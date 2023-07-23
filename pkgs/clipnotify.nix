scope: with scope;
clipnotify.overrideAttrs (_: {
  version = "unstable-TODO";
  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = "22f7cb09d0b99af0aae7109aaff73760ef2dd5e3";
    hash = "sha256-b3EQmZJr4XGzA4j/PAIodRV1upe5t7qVDh95SUttfuw=";
  };
  passthru.updateScript = unstableGitUpdater { };
})
