scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7c338d452532195679af87c9aba31eb4ba84ff0d";
    hash = "sha256-6Cowc7C2hJdKEz0PIZpHeRlRSxRGLQFzwixblNWFO+A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
