scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "26bee8edfc7d475b29acbfb5a0d3c0682799acd0";
    hash = "sha256-4652cPg8Iv6+7JVo7+uPotzYYC5944Qn1sHJrlJl6Uo=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
