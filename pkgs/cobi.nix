scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2f09d5bdde04bc38c13640d6a6094d8d335b8d14";
    hash = "sha256-NpHKtHsgBZvpvD+ojVzD7FAttOI3G62UpCVoL35+q1M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
