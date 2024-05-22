scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f671e3ca7850ef78dfccf46b912fe16d5f78fa4a";
    hash = "sha256-/tjEUKcHl0TZmk2DP9wgw1VI1+uNdMN8NCVn42TlLuM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
