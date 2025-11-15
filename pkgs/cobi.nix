scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1ab6c9551171cb3796fb2b83b76e136cf1137f54";
    hash = "sha256-GtmzQzkIV3Q8fqu3G8lp4bjQlVv+Bj2KDLCibyPlGbc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
