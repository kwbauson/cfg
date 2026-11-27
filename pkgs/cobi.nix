scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bbd7f50d5e3655848e3957b565af3b15b19397db";
    hash = "sha256-OZEyyTScSY7a4xXkk+mjgUNncMOrukt1JYfzfe7aXQQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
