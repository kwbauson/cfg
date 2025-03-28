scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "07f6ed96f59650009f73a96bc228d62547841d53";
    hash = "sha256-pEodPrnqV4P6CS3vhQ7VDC4Gcb5H5G1RvHQfzMboFdA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
