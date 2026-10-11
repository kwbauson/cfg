scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dc2df129269021a5d53969a83f9c00e8bb947ebc";
    hash = "sha256-hLsqmCf6rIfAlWZVxQWyLuwDR3DwAdk7HR+DnohTygw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
