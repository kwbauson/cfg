scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1916d282e1a3c8845b6dd4fc1f130b1fdcea6a32";
    hash = "sha256-VuN7c8Mt6EAQGE86Zm/Uv8Pz7qYvcx4H3dx3aQFqZPc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
