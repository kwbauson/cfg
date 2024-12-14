scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2abf5df29c81017508acec152d75e2b542ca327e";
    hash = "sha256-TEP/Lkv1o45ViVryFZ7oaSd4HeheC+nmfR8bV1Rono0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
