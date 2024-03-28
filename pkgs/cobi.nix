scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d94100118724539fb742580d86c55777f82a8c6a";
    hash = "sha256-B/IA30vrHRlOFrKZlrRPnYR2SOMqpnjMsyE1dzmuZ+8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
