scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7b31f050c02a80f41dbde7c32bf581eec76bd3ba";
    hash = "sha256-+rCbgqXYaD9oiSdeT+an5oVemlUqNdygqEMKSTjq+fo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
