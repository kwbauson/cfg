scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e82a31773d7065fac3dfe4bcc438838f96345be9";
    hash = "sha256-Kg0PGdl5sJErStHQCDVhO8vW2fbErlzgJLRKdG5din4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
