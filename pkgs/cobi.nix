scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cfa8de4addca101638ca2a136a2b5475854b714a";
    hash = "sha256-alYPK6Zog0q7hq1uIivgSLfKtNzdT1CznFCyMM9SWPI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
