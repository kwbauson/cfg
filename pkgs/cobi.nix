scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "47528513e5fed8b9f9fb9a81b18dface824cf5fb";
    hash = "sha256-LzgC/5xxhFIKFww2Ff8CzjiPi5y+XjHZ31SqTGjY2aY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
