scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b82534cc6b188c1a6fbf1621d8bfec4bec717bd1";
    hash = "sha256-0IC1A7y68AnlhWomVaPzPKv0AxILzxdG+QkExzmQkGs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
