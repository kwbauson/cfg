scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "96f11601d37f7062bc4de3ee00565040031cd62d";
    hash = "sha256-4huxpZv/wYYLIPGWF65mUoopJIYfTDOt0CYw3oIu7Z8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
