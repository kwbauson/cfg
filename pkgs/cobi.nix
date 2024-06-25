scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "00d50f07c4ae6fddb630b3502fb9cc6c020abdba";
    hash = "sha256-ggGlSmB7E0xIxo8rxFIACKcAO5M5+jY81prArHZghS0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
