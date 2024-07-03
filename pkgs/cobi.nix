scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "febaf8178d61de4a8d33b3b9b2969753b2ab49e0";
    hash = "sha256-KVHAE1pgRMDTeYQE858T3gIrfYIbD6xsdTfnNR5Vqew=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
