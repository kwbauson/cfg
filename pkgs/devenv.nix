scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-11";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "63d20fe09aa09060ea9ec9bb6d582c025402ba15";
    hash = "sha256-s5NTPzT66yIMmau+ZGP7q9z4NjgceDETL4xZ6HJ/TBg=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
