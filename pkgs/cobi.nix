scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a1658d80b96298ee0e6db0b0319816e9d2ab0a6d";
    hash = "sha256-RQjlrzECtHkULBr1FYrHA020hjP9L7ntcyvYQQ0U3Lo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
