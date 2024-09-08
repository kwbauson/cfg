scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9a895daae3cc14ac7c7fddabc3c874d3eb2973ed";
    hash = "sha256-DD6EBPEQEKibZdshDw4nB2IdeIx6bie435yoOYXDX6A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
