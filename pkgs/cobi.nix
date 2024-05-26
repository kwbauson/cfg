scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ed2934026f5f6023f7876afa5685d209f90d0738";
    hash = "sha256-HRPE8xKJlD5BxDdblDAIYEo5dURvASc4K75iq6XYenc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
