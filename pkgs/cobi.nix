scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a8d2cc276f2ea7e5c6be1ea58de40a354d8cb69d";
    hash = "sha256-NaXongxYK/E4v+TILjTM194Nom+TUaCGstGP3Ubo4Wg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
