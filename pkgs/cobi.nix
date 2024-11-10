scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fa32731b1651c330283ea071ab3f1a5edf5ae18b";
    hash = "sha256-OwICta3IqPnUMO9YS/zgn0ZAu6Uwny1V11mtMWYZt68=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
