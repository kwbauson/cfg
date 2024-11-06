scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7e9c5c26f3a16077a423a94535ae8e0df44608ce";
    hash = "sha256-iLZe5iiM3JKiB5jnkLFxNLr76k60IKPdFVqEdgP8Bl4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
