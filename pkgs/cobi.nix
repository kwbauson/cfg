scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "594dae35324a80569c6029bad868a09ba86ee7fd";
    hash = "sha256-plv5q3iNWeGXI8P7qjv6sanqhXFVuOvuNOeOZ7V9zYI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
