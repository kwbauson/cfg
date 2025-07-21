scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3f2f69b5b5ee49ef6e7d13706ccd495009d39394";
    hash = "sha256-kELmuX0RazBTuuD+NiodBcajq5zIVQ3QG3vWTSQX1gg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
