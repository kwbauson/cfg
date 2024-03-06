scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-06";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "3bf3de06d42600899108603446016a19745049eb";
    hash = "sha256-tcw/jamqSjsNLIO7dFKYkpwC3GoA4pYFzYuuhM6UpTc=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
