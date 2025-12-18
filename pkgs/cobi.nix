scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8e22f2da6293070ad0b013080feef5671ac26dcb";
    hash = "sha256-lbLOodKMNjETsonre9nRyg50I/nOwtc7WlEjFctmA1o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
