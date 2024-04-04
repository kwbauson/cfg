scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "130d29c5484113c5c5a5a94f16c88e5fbe46d0ba";
    hash = "sha256-1j1G2nSn4lqciKpvPqzfGF0Z7ET+PEJjmO9YsJGCG+8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
