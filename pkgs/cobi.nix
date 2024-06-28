scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0c75c714fd304f12becece09bc701cf8598f680d";
    hash = "sha256-KGi+1FSI81v/eTFj9/N5dO/GwgE4oWuMUFHbisp+Rn0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
