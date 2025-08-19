scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c4c546ec0d0125ae09a325cecb7152dd74baeee7";
    hash = "sha256-qMdULTBG3WmcNBNMB9xpe+SBD79QWsP6kwwU015xRRA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
