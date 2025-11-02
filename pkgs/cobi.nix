scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2304bf8492c166753df7e3bcef8a801c73f0582c";
    hash = "sha256-HCLmA6CA5ajg6//ENGDsRKlAQArjgurm42cj7PwwaS0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
