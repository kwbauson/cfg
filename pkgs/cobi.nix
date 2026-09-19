scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "614d75351e0bb6211011385c8e5af2c8c6d2f497";
    hash = "sha256-SYFCe17jAb3TPbDqfPfUUJhvY/fkZo3pQjy9InsDLZw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
