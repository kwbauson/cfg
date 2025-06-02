scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c00f9508acc8a4f7db8adc1ad2055eea7d73640b";
    hash = "sha256-I9aTpFqrXXFAOEiCYzjqhADnk5RWAUGsg29BcyfXgLc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
