scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0cf1ca7bae18259909930d9625ca4a7fe8049e22";
    hash = "sha256-vl18q5FKJvQH5fjxMWA9f4cZoLizsOngYHYAwgq/rXk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
