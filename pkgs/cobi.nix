scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f8b8bc1508c14dde1f3ee66e242e46218dc43db7";
    hash = "sha256-/pWPxEgTMLOHbtvrL7V9QD3Dj6DHP/9QW6AqBkOSgSo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
