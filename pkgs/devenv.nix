scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-16";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "eee80243720b7f284128873a9694a520d9967b2f";
    hash = "sha256-9SF/H8oCWv166q5o+JtV7tK+koydgFMu02HCB27UWpU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
