scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5148c889121fdf6c9858320756fb67a1de2bca90";
    hash = "sha256-HBSCoc4i526tSGUZW24X44RLQoogDn8i2KZFUudDtkU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
