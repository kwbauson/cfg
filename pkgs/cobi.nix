scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "942313b3292b49e4225572d4e3b793c050f7f317";
    hash = "sha256-n3mfT2mvUjh3xaHyYGpJpUtpB5htDPKA6WfCt7oM+4c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
