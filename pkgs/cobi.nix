scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1e0f1cab59fe5094e077340e926827845ba9ad12";
    hash = "sha256-woJ2CGWEoFU92VgyErEiZUB9WpsghY5LhFjdM6nNKMk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
