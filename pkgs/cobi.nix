scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "acdeac721e04f93ed74d92a050747a09d5a07804";
    hash = "sha256-iB56E+dC29ZQntJsz8B9GOG0klCAJFVFP/0zDOil9EQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
