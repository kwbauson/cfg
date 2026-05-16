scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "61d5915004c69e255c7d357f2be4bd3779b1fecf";
    hash = "sha256-3xcfwm/7QbWoLPKZdDpZ2dSfezBnye1WI+pTr2UkF9s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
