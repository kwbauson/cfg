scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "63e5892f82504db10c773e2a3e1af0e830a24321";
    hash = "sha256-sNJRHKHXZUh3mVILZab3ApCwT0bl09O6UkStxsMjo0s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
