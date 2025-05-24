scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e362ca11e9a1b5540fc0281ba5b9810ffe258b8c";
    hash = "sha256-dFmXq3bvQY48nHOZog/HGbR0z5YDaaNgVfBZSRjzLRc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
