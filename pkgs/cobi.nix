scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9c6bd106ec068a2eafde5b9e8184c96a4f8d0ffc";
    hash = "sha256-pE/ELWQhBsVtHbfVhahmZMWesR1HqQ1uOyeYFjXVPU4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
