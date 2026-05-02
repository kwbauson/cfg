scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "93f624db3e68264c167b0959963f00c2c1efcd09";
    hash = "sha256-0jDm/9h7fkwB/oDXw1jtXuugsIZtKfV1+M6Knkf4fTc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
