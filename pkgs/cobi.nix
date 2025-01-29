scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "deadb5d8f5ba3461b0137795ca7b6fcec7306b20";
    hash = "sha256-3Rlp2nYjUcbm6H+ABiherLnt5BNs40NfacEfk/fkYmM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
