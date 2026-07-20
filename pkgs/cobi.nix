scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "31fe870656eadb142fd1cb18f9d1a2100c1ffe32";
    hash = "sha256-icj5rcGUewblMwBcDQYtnpYszP2Ytod9so2zjFyMy8w=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
