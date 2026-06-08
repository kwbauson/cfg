scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b94593a81e9a2d04709684951d7148dc01c2435b";
    hash = "sha256-O1K6lesZJp2X3mzUJcYdYPkKnRfKjL+uUBofIapxk+c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
