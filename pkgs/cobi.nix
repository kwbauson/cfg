scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fc4731365443d2eaeac427e0508a4a9f81e86f53";
    hash = "sha256-NlAK16Fx+3a2RunW2nOzmPWdXbxso3yY3VsPCcK8d5c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
