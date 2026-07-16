scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9ef0424a65a2034188ae3ac60e212703ca806ea1";
    hash = "sha256-Ugw8LHG/IkfeHDTWZaHBKwBGGYx+dO/q5QOTWuA+mdM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
