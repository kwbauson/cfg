scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "403b83549d21ced10a80e3d43b5801e232555400";
    hash = "sha256-fFPJ6+diLzN7Oj7MgAVx6zOBx6HEKNm5pc4v0hugsT4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
