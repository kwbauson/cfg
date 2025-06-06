scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dd6708ba92045d9da06dc5f6b03ddad562e451f6";
    hash = "sha256-HVexA5PkcZM5wzQtZs9cSEsvW6cAS584hRgkvIyB1Qw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
