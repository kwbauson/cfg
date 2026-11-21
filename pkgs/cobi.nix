scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4d64174f858b5e760b1e008adfddc51abc1e62e1";
    hash = "sha256-YQGXltQgtDbWkxzfwb9hWtkCQzMTmzWkuSxGAwmYRkE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
