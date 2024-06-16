scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "198a8e918042bd3db5bd05ea4b540e842e582ad3";
    hash = "sha256-HnZWhQaUTnzNZxGDu3EPYWl6oS/2cOAZ1vaG+s+b3DM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
