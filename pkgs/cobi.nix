scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d9c15f80551ae478123c60de75b5216c2dddec81";
    hash = "sha256-LAyOECMTYPI13y8gvNj3pNI5wc3c8p7CcPhWkQyUwSs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
