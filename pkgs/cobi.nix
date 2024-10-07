scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dbbb3e49e43d7ddaa1389f0fae0d537e4c858a8c";
    hash = "sha256-AekJwYZmTZjNmpiE7kxdBahR3lvJrl9w90vg0dXpi7s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
