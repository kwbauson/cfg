scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "825ecbdc821f5a042856c1596d0e6c3c44e1f1f6";
    hash = "sha256-h8QfsG3xA7/3f4wEEb+6Fma81GbDMwVbUv+vQq73MgA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
