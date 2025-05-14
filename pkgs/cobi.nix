scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "65edaf0408c186ba1ac0622e5849db253ad71260";
    hash = "sha256-fuuzMjM+kYqO5xgw6In7FKioSenDaGvEQ41h4U/+Bic=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
