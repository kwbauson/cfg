scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e1a13b0d105d81e2165799c3bf4ed1723f1cff1c";
    hash = "sha256-mlcmiK16bsFhcp/bexHAf2xcNC7lRh4grxEJUaQ0oBk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
