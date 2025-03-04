scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5eadddb9ee7bc9bf212fd279a0f3a171190e50d5";
    hash = "sha256-BPwevd/rel7PGpuV/xEgyD4RDP6noNeMl1KIXXm8yYE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
