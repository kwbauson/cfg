scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "07357c02159a3b3c76ad799b9a55a19e447f2d6b";
    hash = "sha256-1LNJ1cGUtZwY/yF8eLRau+iky/PCXizF6gTMtbfN5uk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
