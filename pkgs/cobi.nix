scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "be6a5dc195557c6f18ebe6864dc5e3ef13ce86cc";
    hash = "sha256-umI4nLtM6m7iDjfPXDd5qZeEgynXVr2L1IiNFt8ahjE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
