scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d47682a0bd1b1d94173a9b4385501f8a0e2954cd";
    hash = "sha256-tWjug6g/f/dU1tCaq2spe25S4XqOSaJ3/8ugBHlVuyo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
