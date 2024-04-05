scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e14a28fc378b5194ea7b1a9b09f76611fc68271e";
    hash = "sha256-j7TPZZ+IUEFFThKmMo4A6kCXsOHoGmxyH2HZ8x/4X3A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
