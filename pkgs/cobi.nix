scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "168e678c403b74681b026057beb1980f7ac811dd";
    hash = "sha256-yL6vXX2AwoYmhtP5vu7Ay9oBU35vLjwXU4c28stHaMY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
