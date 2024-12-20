scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fa9735e61d20c22b66ced3d0206c21873233ac10";
    hash = "sha256-Qi/maOJMWdZwqwE7lqqMAAN/DlZIMM7aqvyBMUB8gfQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
