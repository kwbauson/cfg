scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "79a89d4a6f54cb06b5c7c2c8b06af82015ff5ebf";
    hash = "sha256-d+fOWmWL66DOnTwDlh8sj0D36Y2Zkbr2sVZ+kngRuq4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
