scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "119f46addfc0fec293724e4cf1c5244ad0c022cd";
    hash = "sha256-JR4kerSYT+1itV6jrFQS65ncDvUcrtHGnnWNBGULHiM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
