scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3144d935e92cb4d356369d6be915d9be42ff09d1";
    hash = "sha256-FOE5bidU6KcFVuONIdwzj2EBAJGvq++DZbL0w2WtWSQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
