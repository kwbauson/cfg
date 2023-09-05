scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-04";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "f839f486b98609f3477c0410b31a6f831b390d48";
    hash = "sha256-6j1oNRpjGseDbgg6mJ9H3gmX5U+VAubOLV+iFL9WW30=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
