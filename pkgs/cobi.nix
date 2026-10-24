scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3792e68e85075a7839f44b045e529fc80af93dc8";
    hash = "sha256-BcAu3pypkzoDtGonQ/Ec3ufl0dRBQp8efFY9rNL046U=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
