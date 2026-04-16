scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2e567427420ea8811f38fd5da1bf0e2b5efb439c";
    hash = "sha256-HmPNBqaGWWb+KVdO9DSLgAeslSNbdiryMsdbh3cJ1h0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
