scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "846398971ba7784cbc5d015d5ac88372adb28059";
    hash = "sha256-JiNxdRhjGECdoe6qTLWdvmi9zcJeJizAFp9+p+/HTYc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
