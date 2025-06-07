scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2211ccdc90d9009b93198888a675cb8b97eeadb0";
    hash = "sha256-DDzS7sL4ARsEYzPZz57QO5har7weas6Hk4+PoATT52k=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
