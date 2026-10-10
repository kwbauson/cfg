scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-10";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "f224e3e8852cebbe1f74a2d43537e5e5eece8368";
    hash = "sha256-MYNywU2QeJ22mb3nd18TVrJQAPfDaI1ZGYj/QVh8mhw=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
