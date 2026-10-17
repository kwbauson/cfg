scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-10-16";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "e125f8a9b2b7c9414f780604cae02182e8772597";
    hash = "sha256-wdmRnrB60UVo6MERmPijnVoyo/ialR1b62I/NrXGLw8=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
