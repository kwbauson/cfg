scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "782ad0ee4fda20824d06451db6bda52d628d342d";
    hash = "sha256-vuhm8pcrd7XsMEnxNkB9H+yYrHqLXVlY0gQ+KF9fyvY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
