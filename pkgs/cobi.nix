scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9959309e08f57bbb8e21b21e220f38cadcd5554e";
    hash = "sha256-6tU0kULcezKxCZ0bMQ3FPaCLwItMYWRnXMgUv9vZpD4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
