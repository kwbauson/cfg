scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c9a0591f70e6027aa0068987ac2dad5308113892";
    hash = "sha256-vzTkKu+lA4KaNNqXnmoqZumRHVTIKGbM9wzn+2nVHfE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
