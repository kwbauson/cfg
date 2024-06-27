scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f9ed1e3e3978360039d888218c3076b00d3f22e4";
    hash = "sha256-FpZHFT8YFtSjxteB8U9MMXKs/18Mh77lE8uD55kgOIE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
