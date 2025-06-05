scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c112782fe18bb338f7536a25161ec324b3364b69";
    hash = "sha256-5zOJxXPCH3iuIom3DqeAw5oHFlHTO/B+R3ORhR+rvIg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
