scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bbaed741e320bfa49e4d3acac7952770bb9de78d";
    hash = "sha256-AuarZD918fdA2cU1DuvMgFlaUBqFLQRwnUAaD0CO6DQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
