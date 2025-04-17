scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ae097381b75db368b0bb535821a5d41bb763a080";
    hash = "sha256-F58wCJtZP6YM6feiL4MOgKCEz/FeMzIlRRqQxjmnG9A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
