scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9b1f7f14d5b79a9ca0311cda8290ecfade30aaec";
    hash = "sha256-6R3dh3SaGshOJZALuUN6opQIWUUWg6U6HVTMputz+aU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
