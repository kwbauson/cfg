scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5e44a2f297667b4f2a9101de933a72e5badb5711";
    hash = "sha256-vi9gCzicAjCOWzZIhpxp+NMyXaD/o3w6B09fckPucvk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
