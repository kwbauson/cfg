scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b6696be4409c44304857ac4eff1833cdcb45816e";
    hash = "sha256-YRL5aPqcN4UotIa9DCMvxCh9mocBUY263csSor0Kyn4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
