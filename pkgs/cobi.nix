scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "468f5b477bec6e73e92c82d7a200b93f17e58148";
    hash = "sha256-FtP+FxAHDjBTomengawKjgdHFjY7DANBtbDSlADGBdo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
