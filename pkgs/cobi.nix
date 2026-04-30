scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "74268bc4c6789cdae0506427a3b2ee787d5af82c";
    hash = "sha256-QXg9t7eGQfManQ/U1rax7ORh7+nbWftG1c/OTV2oiQY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
