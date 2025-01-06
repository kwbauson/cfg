scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "19bea8e09bc6f00c9a8f2be3bab53bd778485b3f";
    hash = "sha256-jWh2EZCVukbZNXeGLABzrEPlgFN3ydZL9sjLbZeaWuI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
