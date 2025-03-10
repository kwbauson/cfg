scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5d23159770b6a6a2e58b558669a3977c13541d76";
    hash = "sha256-f6lhQyeWivazBpC4TxAq+7kCx1GeZb9qAXHI+ru5Q0M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
