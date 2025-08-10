scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d791f6328539a9f53b66a0abb70803ccdf60c3e0";
    hash = "sha256-0Cf80/oobu1IgFEBFNceSqoWd1M2gV5WHXCzMMcez/o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
