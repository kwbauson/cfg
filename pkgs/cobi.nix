scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3a971e8b13e1690ae0bdf069ccb89a088c1f8760";
    hash = "sha256-Y60GgncGSKohoOEozNZcnVkPyAg/X3mOSNp2lwaLgCQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
