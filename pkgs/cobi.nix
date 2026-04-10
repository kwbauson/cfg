scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bc5a643ef624290f75b2df1faaf755eaa8e0d19e";
    hash = "sha256-lNeJesfWQhGpdEwbhJ7Sjy/j11DkxRwhW/lyQRpZnU4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
