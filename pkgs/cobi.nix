scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "208d763778316991542bd3aab4056b92e0ee4b27";
    hash = "sha256-BJ+Hbp1ffhCCW4kG7kSxDySqTlKB8VPR8WKvgH2au3g=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
