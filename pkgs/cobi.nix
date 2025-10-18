scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9140e166cf8ce73ccea20b0cb13085d1dc9de42f";
    hash = "sha256-xW9rzC95bPLmvklCdBBZf8DU+8RWA94wQAH3lRbXTNk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
