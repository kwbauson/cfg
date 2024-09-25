scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1bdbe64e49b5320557f7b5fccb3ba9d37307db09";
    hash = "sha256-hLo0D0shnuoyAHHzpmemdgi8lJmvErpciG5Kl9y666Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
