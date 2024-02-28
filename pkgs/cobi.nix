scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b88d9c03947d89580388158383626934c4f2f026";
    hash = "sha256-dTGa5WK40sNsS8GSHpI3dKrW2J1i6dhq4QN55P1X9hc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
