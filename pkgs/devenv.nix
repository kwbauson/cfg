scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-09";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "80e740c7eb91b3d1c82013ec0ba4bfbc9a83734a";
    hash = "sha256-AhaFZrKIpU6GYUaA26erOQg2X+YHHzJpJ8r1mBHOaM8=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
