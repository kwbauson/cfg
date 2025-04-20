scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "699260927afd4828a6f25eda0c8cc4bdccd2e6e3";
    hash = "sha256-KOrHEbhiZiEQu8DXWDRGL9Y5qZ2OUvjvFQ5ehR+5r7c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
