scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4ce9b3831c81d981e1f2be8eeb4d7950faf6b6e9";
    hash = "sha256-FC1hHoHab2GRUp4Y74uQuC6CSssS8wA+TOwMdsSyrfg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
