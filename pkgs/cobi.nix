scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7a5f293929f96613a6ad5ad7fb0d6f4ce7be46dd";
    hash = "sha256-0vE4OI6ZtDyoC5m1UWXqrIT3dtf7nrCUq0U0vMJD+gI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
