scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "78392a3d84d7dbb33c2c91cef0a3adf55d7b0a58";
    hash = "sha256-AAHAaUAvC8nnJko+72IbPJFScEfn0gXbu6cN00h7zvs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
