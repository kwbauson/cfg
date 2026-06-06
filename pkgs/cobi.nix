scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "91682a120b2b9ae0cdd5064f8e7227e546139efa";
    hash = "sha256-CEXkKtmMGuv0dXGHc0b53VZUubMYduSuYY/Z6xsFEw4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
