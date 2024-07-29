scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f810f5e1fc14a5f4f42c688b7dcf44349e72085d";
    hash = "sha256-B93maYmJIC4KPlHuTZ9FNW3h6pSUXfe1J1NVahay33w=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
