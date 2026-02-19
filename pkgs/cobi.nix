scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-02-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5f583e4a6a4ddbb21d491c2c3a99f80558ad8975";
    hash = "sha256-yw0folmeD0T3HZHiS9aVBb5sPnw+BNhrmd25R9lAZug=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
