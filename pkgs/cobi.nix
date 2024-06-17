scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "64bf193ee338a8c6441b294dc38ec00e0941f48f";
    hash = "sha256-vskScj8O2Ev7zMPbKBWGdw/qBVOn8sDc3B+00vs8b5Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
