scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "88eef828867b8c81a66eb4cf745fc97446247423";
    hash = "sha256-hbVBPrZpxO0TkNr2fKiY+kR9ZRTVGxWojKOuz9uU9nU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
