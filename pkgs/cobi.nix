scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d41af83319ebf9f0257bb0d961224ee615501e83";
    hash = "sha256-j/esh1kn8VMnyh16usfyzgALEKmNcgojDGyeUJs59c0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
