scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "adee795f3e428d44e7309dba3fbdf498d42c29e1";
    hash = "sha256-OhTt1cxS6ZJ9rtMqcmISg7cCqOcRLxVDe0Uf9d0TJWM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
