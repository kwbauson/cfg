scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0e8b7fb026e5ba2f0edcd0eb411db34adf01ef24";
    hash = "sha256-vBpM+ksmleLImKBdnuJ4c9OvQcWJlqmcBqZ+MPOG0TE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
