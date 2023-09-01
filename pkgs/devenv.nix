scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-31";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "32f89b57ca513ee520fb691c572d1ccb6c85cae8";
    hash = "sha256-+BlTmtyPLiNanjlnUzhz+4MPtValL8+OYcDRq+2w4/M=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
