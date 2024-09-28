scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fc562d13aee39801f5ce4c2cf4128763f495e87c";
    hash = "sha256-RGI7ZBU/PW+XCJFzizfiDB+d0eMhbgh5Xr3XaaQ3yyQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
