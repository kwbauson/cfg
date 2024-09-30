scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8f5e090e11ef504f9e742394924faf79b40242a7";
    hash = "sha256-v9Ry4QVehIuBX4l3+5Ynk9du15gEw/eoYWlRAVp75sE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
