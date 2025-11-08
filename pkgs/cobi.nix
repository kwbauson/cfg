scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3f1629e146a155024dd28719a7b8b5256dae8848";
    hash = "sha256-THvXhf7kyq7POqvC9+PTGWH4OV8nN7NTUwYiJPmn0Yk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
