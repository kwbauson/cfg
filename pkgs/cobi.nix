scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d972cafb6a9bf5d54744690685d631369096dfa3";
    hash = "sha256-RI529kZ1ce0dnyzB2rvjCHHzzP5LZ1pr3FuPpIYsTBM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
