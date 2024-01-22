scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-21";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "aa237a7b5605b4f58714762d1f56627dfb1b3dfa";
    hash = "sha256-Oz6K7aGvUWYv4U7rouc5vtZ9WTv7L5vkgRrtziNyquY=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
