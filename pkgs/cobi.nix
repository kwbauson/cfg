scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a6b81fe1f24cd74c9c52ada076042ef8fa1e6794";
    hash = "sha256-hBl7WfgJShiBbnvnqJ1XTTRoTWQHNV2ntJmochFYn6k=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
