scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6518ae590ec45c2d128c07831442383728cde9ce";
    hash = "sha256-UOBtEuOxYUWhbAaD94Z1SBIs8vW25rqn198fdekoYeE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
