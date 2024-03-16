scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7715cfa96e591bbbe6386b2816f163b7cf59c2dc";
    hash = "sha256-QBdR90L3w62lwFTEpuK4bDk3TGrOkxxDLMU9r6FKP3o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
