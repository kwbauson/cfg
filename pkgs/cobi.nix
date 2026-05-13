scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8d3bfeda65a88255e94ceeb5e17883c42ff8feb9";
    hash = "sha256-duoLbmkTjXC9cwLdhkobCyTSNSau1tOsp61zkeyXHIs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
