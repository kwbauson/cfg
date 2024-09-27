scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c2c942833399907fe7279371d58227939b039c95";
    hash = "sha256-ZDev9WTUtjIA5HoIvyneT3vZhEb3f/KE9TyDSijN3ZE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
