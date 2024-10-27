scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cef685ffdfe528421d08466844e6e664db3546d5";
    hash = "sha256-TOSfOpt3vmAcKmfsDqsO+To/jNosU2Bwu3WAPbJ1l9c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
