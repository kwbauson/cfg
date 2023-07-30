scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-28";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "6568e7e485a46bbf32051e4d6347fa1fed8b2f25";
    hash = "sha256-kOXS9x5y17VKliC7wZxyszAYrWdRl1JzggbQl0gyo94=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
