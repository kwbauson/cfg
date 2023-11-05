scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-04";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "2c0eb6ed8641f16eb577a1168e0df95dbe0679c7";
    hash = "sha256-/0bquV2yOvWOQ0A5AprMALOeZH+8fWFuT9NBfX2ivfw=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
