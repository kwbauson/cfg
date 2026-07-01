scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b1e1ed272802cf8e3ea8a8b329617eca4b3ba2e4";
    hash = "sha256-gtYZuzodI4zIS7Ervl2hdXSqwD7pUkoNbM8u8p7qYeI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
