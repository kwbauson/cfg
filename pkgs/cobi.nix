scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8029bc41d1c3d38e35858f13bfb0590985bd44f8";
    hash = "sha256-HfKoor5lRfebRDZhIpb5+wy4uW4iEcMIw7oCq3+ltm0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
