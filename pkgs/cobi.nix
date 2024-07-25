scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "366a7ddbd76187cbf1bb9839228e0cb442b0cee6";
    hash = "sha256-e0RFQABDqf0CBY+Bf9xAuWSeVHckXSlOIKXk72+F7so=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
