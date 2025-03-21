scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9361b6cad8f6f5d23cf450b0ac3879ec0ee89742";
    hash = "sha256-4XRQXC0cmoW8+dYfkIygNARoMkZBI01u/iCmikH+yi8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
