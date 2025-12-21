scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a2ba5b8c18b91f32a5d930bd33e49c7329a5ab72";
    hash = "sha256-vUJJonpZmH5OwH4iAufdT11PYfbqtCZ+lreN9aiG8m0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
