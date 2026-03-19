scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5ca2c2a9840d06ac1685091b495017e26d323555";
    hash = "sha256-MwJk9wP1yVnO8lZnt6acwMLGPgUVhAZl7ZwESDKS0bs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
