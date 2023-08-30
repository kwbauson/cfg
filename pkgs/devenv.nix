scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-30";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "3654eb5d47218cfa2d12280ba5ac1ace0a9dd225";
    hash = "sha256-le4CbQz8rKheEkGZcZzmx1ycCQ4tjFMAkcpu3Uq+tEk=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
