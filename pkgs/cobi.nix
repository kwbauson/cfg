scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1d1760ed220b99701961bae6268f61779c3cbd85";
    hash = "sha256-Go2/KYKLXhlp2iiTP615Rn2Q4izC2f73PfqafM3ECiM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
