scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "313a406576c47d4f32b2907729c0933431ae0bef";
    hash = "sha256-WsSZiFow69OVJLesg8hbV0n5r3jSqxPXVbsUfkx0wqs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
