scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "046eb18454ef5041bb5533d1e50b257c98cc188e";
    hash = "sha256-4sG2SFKEF3kxkw5V9XjTyWKQTbxFsMjO4NzpKKVKDy8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
