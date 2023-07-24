scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-24";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "9b6566c51efa2fdd6c6e6053308bc3a1c6817d31";
    hash = "sha256-zM7OwUp+BZPgNVJrdSxtV93Q+QPHUX1fd1Qn84SswmI=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
