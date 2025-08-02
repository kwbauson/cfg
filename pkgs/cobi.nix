scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2ec0a58eceb0f51612a58755bf69e963ac24d706";
    hash = "sha256-gkcnr1SOXZ5wdkWDLthG64N3Ym1B+Z5z29RtbL+ZpRc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
