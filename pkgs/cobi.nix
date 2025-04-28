scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "df75801d1fd6d91dc6ef3999bfeb0357d7145eeb";
    hash = "sha256-zO83tUo6JUL/WDVbzGL8oRprPzhzimoYyHUVuLLAdUQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
