scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "62e6f6f1a1056ef49430dd1118bb602c59417d5c";
    hash = "sha256-gfI8OLW8DJBXDs3gZU1VzcLsEUomxBzIB6hF5Dt7rOk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
