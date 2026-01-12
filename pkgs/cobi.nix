scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4901de7b373ad80b18b181e3b14fe75739db8262";
    hash = "sha256-04N4QtGUiYtesxKYKn18Wbq4sMjyP4Sku3VFKqk6MWM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
