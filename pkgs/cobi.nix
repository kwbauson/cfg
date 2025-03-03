scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1b91e3c67a7a25a010001aa233bedebd6eda43f1";
    hash = "sha256-IRLRCy1iGTPeIHFg7GdchLteK2wePcy3E9KtZr3p3Iw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
