scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "baa274189623362603ef55a3b87c05095950580f";
    hash = "sha256-QBd1YFo6k05qTRXZPurOFLoeNs48AyFX8//7yXfw+ZY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
