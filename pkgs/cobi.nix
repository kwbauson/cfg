scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ab1fa9ffe22458cc9facdede8c31f7aac5698404";
    hash = "sha256-JZcfpIEkxo8HNzz4wvwgg5zO9sbz/+owbZO+cbKmrxs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
