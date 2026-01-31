scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fb6726c349fa75c8f12fa22c9e59190ae85126f2";
    hash = "sha256-mTAPV+zDCFqA7aQCcxzLvfXrhBKSj1+zWQA/Tdevy5I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
