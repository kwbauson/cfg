scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-05";
  src = fetchFromGitHub {
    owner = "feel-co";
    repo = pname;
    rev = "acd3855d7e0d9bc298a0019da46452c664f24081";
    hash = "sha256-attdCg/FjUooYxVidEDR5wVeQ8aAPAj4b6HQVL17Tng=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
