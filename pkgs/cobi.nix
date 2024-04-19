scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5947adfd7ebba86fdac9bc0856c389b4f8d90540";
    hash = "sha256-qQot6lQ6cWcuNX2wvsteJM2Ob017n1qakNgxPW44oFs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
