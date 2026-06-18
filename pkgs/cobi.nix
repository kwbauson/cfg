scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "83d4c8ea1954f38a3919dd78ec2eeb13765f7729";
    hash = "sha256-S1HSCTcWpVK61btAr7AAysJIb4lJXsx7F2NAVjLwXvw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
