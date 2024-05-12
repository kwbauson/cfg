scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7b940a2c4ce60c0172de1601701122aa2aacb385";
    hash = "sha256-bnPnqclhyHmCJe8We+a4j6cFE5CqTCzVakd/vfNfU14=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
