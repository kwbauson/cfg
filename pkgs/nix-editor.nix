scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-20";
  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = pname;
    rev = "b5017f8d61753ce6a3a1a2aa7e474d59146a8ae3";
    hash = "sha256-Ne9NG7x45a8aJyAN+yYWbr/6mQHBVVkwZZ72EZHHRqw=";
  };
  package = callPackage attrs.src { };
  passthru.updateScript = unstableGitUpdater { };
})
