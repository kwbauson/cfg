scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "304f8af66c6581d36ff490cde64f0693fc574113";
    hash = "sha256-gdmmj76vJ3i2MPKABDviwIw1u+nhLspJ0vJdzcS7jUk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
