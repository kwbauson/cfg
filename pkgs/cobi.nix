scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a60f6cf8780c0e3b96ca75a64d0d5f311dea0a77";
    hash = "sha256-N68oaFJenKbQxbs3Rzek3lsgac17BJ2pdSl7spW0Z98=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
