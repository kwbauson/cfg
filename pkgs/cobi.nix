scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5bb7e93fbfbce3262db8adb51d8dba05fa0873cb";
    hash = "sha256-vER0X2jbQSSRNVxghOUIdjzHZSF4H/E4EMT79NRJ8ok=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
