scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8bbb4960e7c16c59a686a29f31566cc9bbdd0c46";
    hash = "sha256-R8pBN1WjDhzOm77w+BSYoxz/dOXyugNn2Tx0fES+3gw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
