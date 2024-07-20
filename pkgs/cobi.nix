scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6b1e2bb8219994b571615e118cb0b30fbe520802";
    hash = "sha256-0jbOeFUxHheGBYOF7ABHChWsQtn/pvJen3NDHEqGaFM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
