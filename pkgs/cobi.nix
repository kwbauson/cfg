scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b9d7a50fa685ca26a129fb3752225b360c2db464";
    hash = "sha256-hmUu8ZD6tJ1IMELc6U5g8NUn7DyoMDcQJsTlUP9ZOXw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
