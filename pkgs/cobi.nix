scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c0022e1397edcff894b1e4c9469ab748fbe4886c";
    hash = "sha256-3hJ6OC0PyzcI22CCb0hOvhgdyGb1dNYBuaZ4ncmf6F0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
