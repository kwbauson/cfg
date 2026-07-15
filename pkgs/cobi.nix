scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "891d1a1c0dcf3c0231921aa3b20d83e53745967e";
    hash = "sha256-B0Kb7c1kA3MIRk9zTCAltIndAxsQNCgRmsCnw3nKqdg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
