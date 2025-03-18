scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2288ce7f0ed00f3215d760ececc3fe2ee6387503";
    hash = "sha256-rlF8xs6kUgVY6EeyL0J5fbsNOmruIa1ajo+JjHFZiHk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
