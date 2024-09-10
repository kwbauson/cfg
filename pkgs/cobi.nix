scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a9444daac988c73242f32843b4de93803d358ed7";
    hash = "sha256-lmNwt7FQoRRUKiNewF2At2cecP/Nbc/0oqrTjyzdURo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
