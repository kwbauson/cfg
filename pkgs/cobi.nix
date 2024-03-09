scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e44fa3dcf1b58aba1f938b433bab04aea0a378a5";
    hash = "sha256-RwlQHlgmFnVsDR+kytknQjD1y72nWpbU6agNCvZ8eh0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
