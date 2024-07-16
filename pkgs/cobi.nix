scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "eec06c4ab8fec09c6cfdae9b058a187cf3529986";
    hash = "sha256-61HW5O6AeWkldiEuHpf0M0ayXm9wrfU5lfkYgAA6OZc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
