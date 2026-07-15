scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-07-13";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "3536f6c989522041b72ba36a6266d13faf7c6ee8";
    hash = "sha256-ipt1PjC5uLjsyP/T3wptW4GoLKoNlvpiI8Rcsiv5tck=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
