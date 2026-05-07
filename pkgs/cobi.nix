scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cefe02c55cce11d8e54f899e1559a094205de5b7";
    hash = "sha256-OPHLdTKXum9l7TeWrLU/GgNQGtRL664nEqdBXKUJnT4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
