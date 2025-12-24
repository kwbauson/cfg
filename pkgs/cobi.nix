scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c3e67cd88b341248b5e88c3f86de13366706b868";
    hash = "sha256-2x8HL4BI17Zhb6WB+jk3C4NvLuXdoslKIih1sDoJ6ZU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
