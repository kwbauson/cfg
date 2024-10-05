scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9a286d172630fa8d9165e4099e08376f0d710ec5";
    hash = "sha256-5iWDTUOCalOJGXLGyh9RyLs/2JB7B2PDZgq8hy91EDk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
