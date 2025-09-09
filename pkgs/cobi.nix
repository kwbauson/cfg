scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "adc46c82d96a2eb53ef8d641f8ac1acc23268cd2";
    hash = "sha256-rZd2UxpIoE43aw2/D/wngivMnV4I5J/0N0lkn5SF5Es=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
