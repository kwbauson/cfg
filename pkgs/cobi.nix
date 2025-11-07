scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a21f5e297b6c60f39e7c7acec37ad804a4655f7d";
    hash = "sha256-Go0h8oZJG6unCl/KyQQ8qLkIx/9EikvChFgbcl0XSE8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
