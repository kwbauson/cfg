scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f5f1e40e8494f562a9dcdb9514c96b61021b4196";
    hash = "sha256-qFgU+ydb4v84owPMEhgb3WuPQuhY71KX3sT/wfRgxuM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
