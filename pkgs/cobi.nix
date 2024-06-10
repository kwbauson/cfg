scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a6c69b7bc5a1ed539146ca409facbaefb402b5b4";
    hash = "sha256-l6FNqd+oNKPzczzjh2QEWjxmZHEfSF+JwsnYuYGJlCs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
