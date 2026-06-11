scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d274f3c0f4884f48c8436adab4b3f1e76c3c2772";
    hash = "sha256-OAUk1PY/9fW1QkndK8cVKKG4DazGCbdr9FnYjVEefZc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
