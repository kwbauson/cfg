scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5be287a48430edb304dbd6667deae8faf33cc9bc";
    hash = "sha256-kHN/1alu6KwpUd6y+eQ+zrxwxm8eIT+ypkUoL4HihRc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
