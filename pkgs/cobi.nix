scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4182e20cbb8cb0d84a2bf0af21c99aac81ee8e63";
    hash = "sha256-1Dy3hywWKj47bTPwf1CDCHNnml4wPYCsyEvzfz+Nnhs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
