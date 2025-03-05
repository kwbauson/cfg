scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "10f9745c3cb8fa24c63d91456f5a9695fc84bec7";
    hash = "sha256-DCNfeh3WqVCevLi2QQ4jovvfG2Hiu/bnCHIuG+MjzXA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
