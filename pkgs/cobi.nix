scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "93068d07c485a028f958f77be0c4cc03da63b6e0";
    hash = "sha256-zyIERPjHSqQtPcrqgoIMW6AhkcoqWxNvWKPjjx8q2E8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
