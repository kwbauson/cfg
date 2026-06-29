scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "621d3052a1fe87040546e776aa2ff785565e9954";
    hash = "sha256-tniulojqKkyaHeulHtvzHTtgjYOkafI4ydQm84t8odE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
