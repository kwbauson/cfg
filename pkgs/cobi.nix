scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ac3acc8d7b13dfb8fc4f8c8767658a98d82c961c";
    hash = "sha256-BNDK7oCzCyTJmSCfv4ecixmW1+5/h6z9FMYhtMqkpVQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
