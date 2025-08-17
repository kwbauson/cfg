scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "31fda7876e5af7ff3cd1e5a2c0065d1f122489b6";
    hash = "sha256-GGSG3NbSc/Jkb7iAYlLwD9el6chMGtH5rjehaXJylGs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
