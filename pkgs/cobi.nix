scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0c27ced14f56971eace61b4431766ccaa162d863";
    hash = "sha256-WHw+mkbY5Pxk7pkBfT50btjRExAsL0oDZQXrQliWiM8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
