scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-08";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "2ff5c8bda714a0a78c11e4402bfb6dabeeddc582";
    hash = "sha256-Cfey2TztpW9zCzW9OI/xTWQw+tkZjRZ0K9iRM2bNALk=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
