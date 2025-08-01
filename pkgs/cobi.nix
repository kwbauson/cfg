scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d3db9e4920c9aeb803fe5a585e924dad7ac10b4d";
    hash = "sha256-Iv0+2A8wD01zOMWvn6+YdD+DA+R+PfxfhLyvgYV5D1A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
