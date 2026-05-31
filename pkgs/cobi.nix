scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6d8388dc774303ecb39e247386feba790e91ae40";
    hash = "sha256-2quJlQKbR7SlpLuIo71wzbdCdx5KOMrUNT86G1mQ2Bo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
