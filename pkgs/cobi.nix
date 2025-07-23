scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "afd1e2792883b3bcbf43456ed238ae9f3ce55a07";
    hash = "sha256-5o7pRy9OWRBPg7DdAwY51L5VT/ax9jgZ/YYhNyWgp/0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
