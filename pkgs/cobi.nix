scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "13fd862c39665e28c554a93b66ddb117c1bf56ee";
    hash = "sha256-rSXAurNrR05ikfPqj1zbGwr2m2f0bhMN65bgZEbMJs8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
