scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2ea3e17f80793b92add50af84c6a0bc52a6c08e8";
    hash = "sha256-EMxgP9bcoidRZp67V3NGoqZOEmTrV/hDhgeMNSHqvZk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
