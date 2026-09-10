scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "76b1a9c651156c6d5d52b124106896e43c02f711";
    hash = "sha256-QFvd+OjxWAWDjOEefZilGvPER4UfzvNgG2SWaxQE8xk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
