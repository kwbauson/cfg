scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0d33263650ad21838bcb3596c8ec3881a3efc673";
    hash = "sha256-GMiMCOAFKgABlO5DHr25VMPXRHhS63RdQqgaRrRNwIY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
