scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "291f14c9aa466222a14403e6caf80fa23bc2e9ad";
    hash = "sha256-+JARZeJkPgjIn8xy7SGY7DwqkegoscSGwx5ztjFnhzw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
