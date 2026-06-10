scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d3b97cd8e52dcdfe969d99ac375485b7d650c4fd";
    hash = "sha256-aPwXBKn+Q/2oKXEoeWUhvolJS3TBcHUGl7gu+hpfxrk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
