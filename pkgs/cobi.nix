scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7e37f24c91463f2c11d0ed069507cda3246f8b5a";
    hash = "sha256-XCucprDjom3MYMw0zJN43gti3cOCSNYMPcAiAwgWFso=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
