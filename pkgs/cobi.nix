scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2d8657fcb2a7a2804d55cbc212a5ad32225c84a6";
    hash = "sha256-//cktJ1cacvhr5/KjMGCtII/Wh1oaF+9r9Xs4VYc90E=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
