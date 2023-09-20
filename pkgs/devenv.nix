scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-19";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "328a162f692e878bdb8d0283d937eadf1684cd51";
    hash = "sha256-Gr+pVf3W9CllxJD0clAt3jeDoLGhxKrmEILyQULalLU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
