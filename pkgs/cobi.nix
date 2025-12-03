scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d5642e2caccf36668e958ce245a1127fade1a04f";
    hash = "sha256-lwZ6KYYV5MbzQxkUioYLik8TEmQcn0zMgPjqhnQbmsU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
