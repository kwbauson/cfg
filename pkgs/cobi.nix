scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5eac6ec468ced0ad2144073d073efe0fa52de7fe";
    hash = "sha256-gBZv9fkoXBpdv+9Uq6nHHCuhILZ4m57jQbFApPGcsgY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
