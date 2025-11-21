scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "95e2beec32bd877b06f3a2914e451270f227ebc6";
    hash = "sha256-45G2NHLg1FR5gRpqd+rXkL2zNFcOV1vTpB3Hym3mjhk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
