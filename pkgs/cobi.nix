scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c8fe160f3b8ece956eb5c3b9d8f61e906df67d26";
    hash = "sha256-7bEZthOlNEe4FVztUjcSWTmWDFbwJ/BfF5BAryCTCHM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
