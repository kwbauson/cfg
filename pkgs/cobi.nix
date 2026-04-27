scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d9f4f9ed8013d9df9fe574a4f389613e194bb096";
    hash = "sha256-LwePdv3+Nitnu5PhhKpwLtvsOigQydSGKM0uq7xmRuo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
