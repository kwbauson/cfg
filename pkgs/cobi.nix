scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d1ac07c7434282287ddbb7531d863c4a5e87efc0";
    hash = "sha256-tPSkgxVgSiksaJUcx1GWc8g7RVdnwOjHibJB2RWlAJU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
