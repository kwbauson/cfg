scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "436b5c088b5ffe8c7f7959738d7d4acda4ec708c";
    hash = "sha256-M38x3xYH4mR1GQjpxtibqtyjDznS/p7XmeZu48Is8YY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
