scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "014b8156036277eb3bf142aef5c4e8b50b6a6c13";
    hash = "sha256-ujvWiJVLwhTbmIrBgpOhs7E1wPqKLVS5eoz31xt3mgM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
