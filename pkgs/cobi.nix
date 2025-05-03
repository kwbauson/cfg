scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "038429241fa46e6737ca3a71d89d6f203dee81e7";
    hash = "sha256-bqroGYU7GUxXIjBFa8ah0N6Ci9KdQlKNDtkaG7vx4P4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
