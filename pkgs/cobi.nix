scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c356d57e2dd1c3862a46cdde1722fa9e1c9e8b07";
    hash = "sha256-X/ubzHIWo7Ce8iYuKmbV8m8Z9uSiSNcNhNqJWDYrSmo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
