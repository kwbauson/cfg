scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c6e2f60264dac2d4335088a07b5852f602e29e4d";
    hash = "sha256-n0RCmUQcRtRn9TIx67QQZZyQBMkF7yEMRh10uadFnu0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
