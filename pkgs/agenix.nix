scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0.15.0-unstable-2026-02-03";
  src = fetchFromGitHub {
    owner = "ryantm";
    repo = pname;
    rev = "b027ee29d959fda4b60b57566d64c98a202e0feb";
    hash = "sha256-9VnK6Oqai65puVJ4WYtCTvlJeXxMzAp/69HhQuTdl/I=";
  };
  meta.mainProgram = pname;
  package = callPackage "${attrs.src}/pkgs/agenix.nix" { };
  passthru.updateScript = unstableGitUpdater { };
})
