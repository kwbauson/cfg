scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9f5936c4cf7ec61c8b9a2235731e06eabb612b3a";
    hash = "sha256-Gd5tPbQPTo6oD9GnQD+nee2FPPO/KzCK1N1TaKGCs1o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
