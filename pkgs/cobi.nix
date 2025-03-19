scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4b2c91536bc75c15b6d9dfc2f86b74581df5d31c";
    hash = "sha256-a/y3jylaw0MhvDYDPDu54llMsetnmAtpFENKkDBn1UQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
