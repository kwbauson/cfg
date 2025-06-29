scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "99daa58a9a5ef743962c37933fa047e6bfb3aa05";
    hash = "sha256-VNs9kCdYzrJWpqA414q08cCDvqAE2MtKqV17tDyeJ5U=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
