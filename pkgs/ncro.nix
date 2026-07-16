scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-07-15";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "e3bb5315173a41d08e16398dfea76a8e8643da90";
    hash = "sha256-ZLBvlks0WfeYQPEMoJqqMDFsBAsFa9dol75SBnURqco=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
