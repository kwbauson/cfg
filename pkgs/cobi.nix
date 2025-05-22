scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b549294e714cea23c59f60e0e78a0010bbf8288a";
    hash = "sha256-CtOZ6NICc8gvY/cGHRCC+SVmqEfb7ZIK5Yzs5jvJ0DE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
