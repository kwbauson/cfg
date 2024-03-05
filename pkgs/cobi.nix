scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f313c1eed1ed9b16c2abb7b1a4a70b64e811a0c0";
    hash = "sha256-cHX1AMIjqS2Ov/U1uVpeUfhcZF79gZCjaM1IeqHnN5c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
