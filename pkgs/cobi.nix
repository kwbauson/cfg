scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b9382638c1f945145481d1c81dff70ecc58b4139";
    hash = "sha256-rNXGM6cBvss7Upks9xW3zZGe7dZCg9slJrOPia8nawA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
