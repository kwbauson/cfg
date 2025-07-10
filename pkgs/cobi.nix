scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4d9de20279d2cc77627c85bae14185cb8d150fdf";
    hash = "sha256-zUb26k8siID54mNje8kJFjqGXiovGxMN2CsZvfXgtNA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
