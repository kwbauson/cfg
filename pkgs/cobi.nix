scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3c8c393950480067baba5331aaea0ee9dc9ba4b7";
    hash = "sha256-pTjlVvWFF83qPRByJnIy6/Yp3qfA/CJoQjf7XbRvqPk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
