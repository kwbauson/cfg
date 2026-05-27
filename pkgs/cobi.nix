scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "44237ed98f60de02888edad7d21f8df093d3b624";
    hash = "sha256-lqsq/ZZuvXtAwgL4jaUtxdMOYBevpCt/VW4bRmNjRVI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
