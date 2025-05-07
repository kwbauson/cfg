scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3448fbac830bccb893a107627b5d2eb98da2e791";
    hash = "sha256-xL9fgTLdTUBce3mzxZSxqbcPi71fR/VngCJVuNK+sUY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
