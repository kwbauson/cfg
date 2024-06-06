scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8df70103ac31234a6cc3dcb10b817faab59b62bc";
    hash = "sha256-CSRy71Ejt+LZbKzQ4XGsImLWB/nEz0LES54s/Ei3R+Y=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
