scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cae69493bad383577056a4a9299db7941ac91229";
    hash = "sha256-wEFSBz6E64ejPEhqN1leZtTFtriTB04GaHb6uzxU3I0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
