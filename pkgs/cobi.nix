scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "86cf6353e1d8858cfe47a260adf71f94f85a45b1";
    hash = "sha256-ZtIuZZxw2CHDnI0bZUYJs2zva1upx1zsbxYu4NQK+L0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
