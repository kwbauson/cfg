scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-11-22";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "b6d6396faa8de1cc0b84ba823a5ee2f369a0595a";
    hash = "sha256-m93+qwpVxFF+EFQNv3b7bnInbY+B6qkHj+X3OmpJS0U=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
