scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c4c6b692e384a39e9568f29037ad935a41934518";
    hash = "sha256-SWe42ozO+aWE9TFrhLsnYIJzSV7JRuvj0phW9v6ZQWU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
