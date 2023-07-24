scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-04-10";
  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = pname;
    rev = "ab2a7e94ca176589c1e8236ce31cd89044e4818f";
    hash = "sha256-eyLPtopt7lRvmRDJx7gSBYUtYGfOSVXarf0KbLbw/Sw=";
  };
  package = import attrs.src { inherit pkgs; };
  passthru.updateScript = unstableGitUpdater { };
})
