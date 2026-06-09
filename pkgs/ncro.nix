scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-09";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "b33e43200b2c28924b1f6a1304f316e9f8d75654";
    hash = "sha256-POz3sWFFCYnwp79EMnal0I9487Q/ir+hPrswfGamExw=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
