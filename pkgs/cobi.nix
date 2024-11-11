scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cdc26c4d41d5ad54b8e321eeccf62117081d05d4";
    hash = "sha256-p6J44rIZeczAqEdUfSCvACeAKmWWovRjsByLv8j9oYE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
