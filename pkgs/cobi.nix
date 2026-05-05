scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "24c3c916bfddc4124b16cc0ef484647ad3b3a033";
    hash = "sha256-T6teSiHhf/kso3DY4wW8dArShgdMlzR8T+lt1ZDiqMk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
