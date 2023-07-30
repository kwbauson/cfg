scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-29";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "da313abf0fb6d21210f6d555acabf40425e080f1";
    hash = "sha256-3EBd8PHd0lbSCMief9eQdzTOvEofnB3koR+Q4wvvDbA=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
