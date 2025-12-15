scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e7d99f521deda65f83d579a86118ded7b1edd7e2";
    hash = "sha256-d2OIO84+V5/d71+kdvXNLrIy/jcWzpDvWeWnv/DlkxY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
