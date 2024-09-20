scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5394871874ea054a8b8034bb70e8a65b804bc8ce";
    hash = "sha256-2pFgEMxf/BrJQ1UF/LgyosU8yG5WTOij/nsNDvHvUzM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
