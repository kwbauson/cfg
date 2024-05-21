scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "05c221b168b41f862a5487c7be912fdeed15b521";
    hash = "sha256-YBW0TdneTyz8WyynUREw60PK/40a5CeWdMHqlHWnAeE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
