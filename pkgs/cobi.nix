scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "62314f84f9d37835cdca30b69ca5e34a62440071";
    hash = "sha256-kRRPxRDKMGAIUUm9utbqRpJq2Cpd1/fPqM8PQvZV/lY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
