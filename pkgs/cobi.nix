scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6dd8f869bb8a66a4bfb865c09dfaa03923d53531";
    hash = "sha256-LgNSxY7749wGexgbJq6dd8aomEig0Mtk1AnCdfurce0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
