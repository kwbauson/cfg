scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "60dbdea21875d715d1da58295a61d9408faf81fd";
    hash = "sha256-Z7Q1DRAGIpdvlfFzzOpUVFWraKaCBPO5x5Ez3tq+FJ4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
