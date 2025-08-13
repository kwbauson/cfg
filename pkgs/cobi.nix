scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4f554c35b007fceb90d3ae050268095c6fdfa0b5";
    hash = "sha256-vw4Ic2XjD7wE1S6xfZIdaRW1lz5JEJEI6ZHzyclQgoc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
