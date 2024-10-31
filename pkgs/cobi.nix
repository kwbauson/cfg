scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "df00ad3261eb9de285c3551371da7b2590515961";
    hash = "sha256-fD7hzsPCIpqRytW59DmO2DhMcM5aYV0biRAJqeFyhEc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
