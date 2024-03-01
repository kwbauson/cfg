scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dba505e647a3f47174fe884d992801e1c0b94a27";
    hash = "sha256-wlsZc+NZ3/Elo1cg+zC646gNw8DywTkFk4fdfh8SK/Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
