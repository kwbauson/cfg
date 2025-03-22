scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "62bf923f3b18c42292ddbac3306dd16c9bc7a19a";
    hash = "sha256-VNm3voNkghsWgz/ij0SuXibILDVKbAAwsNqHT6crBY0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
