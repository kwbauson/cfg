scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "992de6e01e24a45a91c68ae29fead97af1d4f3e3";
    hash = "sha256-K6A2u1nsXpkjKaA0drEM5VP6FwDRl/UNh4KOEqQhkVM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
