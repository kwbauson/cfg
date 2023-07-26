scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-25";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "9b21ab9147b0d1d601f4a6e13c19aaba2858a6ad";
    hash = "sha256-nf3FK1Nqc2EVMflVRVNOGwT0OXr+jcAXniSm9SPM4sY=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
