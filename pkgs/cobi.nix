scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d588d66a1f9c2c21c8c547026b2c2a9d31c0ca07";
    hash = "sha256-JcR9VnwNEYXf04rnqGmQO/bhsbyrSnvm6Nk7rMlXpuU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
