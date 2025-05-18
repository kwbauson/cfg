scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "082e6ec81eb606d1986a9e68b6b64c2ec55db13b";
    hash = "sha256-XDaD8EVcG1/P/se11zUAbaDve6kEC4ggKuVOQTNQMCE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
