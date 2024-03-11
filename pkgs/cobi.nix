scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "16ba3180ba5658904cb9197d184122a8d301347b";
    hash = "sha256-rgI359HbaJ1dkh6zEnUZ3xjh+ZuUr6knYkGMDIytIaQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
