scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8eca055a64ad253b6dfd660922cda67ea5d017db";
    hash = "sha256-GhbhsX5RaWZfy0r+RD7MzhPxThGlo8YgqKI+6fn75Gw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
