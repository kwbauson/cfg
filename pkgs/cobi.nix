scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "11155c7c2ceb62411b7aaf82927f189748230510";
    hash = "sha256-Rn0PQnsxuLCiKopAmD5Xar6yxOLFDllSFvFlgq8uPVA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
