scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "60234c884d6e0674c88cb0e9798435fa11d52998";
    hash = "sha256-Ot9a//Gk0ZJ+Je1lJ89SjVY1GFLD1ObhEpNrfnTiCXM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
