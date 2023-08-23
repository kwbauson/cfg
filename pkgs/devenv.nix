scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-22";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "6b84a85dd5cde41cbf992b6b2445bf25fe0abb21";
    hash = "sha256-pWbQEVSjlDfrrBoHv5XFe+IdYVpJXY8C9Wz7rO98yqU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
