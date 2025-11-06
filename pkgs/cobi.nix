scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ba43e99dc61b00bf923fc040ace5cd71e67587d6";
    hash = "sha256-K3uLRqL2gTe+VvklW+8AKb3sB3yDJdXOHF6ahiV0fME=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
