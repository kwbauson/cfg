scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "daabd563787e50d3cb1eab13abde55f84ac0b057";
    hash = "sha256-FKvqo3be159QTratdgU/jXOB0WsDF5awJEf7xlJZLeU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
