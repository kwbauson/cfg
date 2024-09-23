scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "09b51f32ad90bd3d6f484abe1141831218a88371";
    hash = "sha256-GAub4KM5CV7InVsM/7+E8X5est6Kl5ImqAjSzW6z9p0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
