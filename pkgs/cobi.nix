scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e47a265886fa3e9fa4c3f398b1d3b90f5ec31db9";
    hash = "sha256-OHKZ3CWmTG+RilVBoru4UB/Sh8Qk9t5PdoX1E/4s1BI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
