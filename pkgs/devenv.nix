scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-28";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "68ea687ed567d578543d89b47281119a3511ac08";
    hash = "sha256-vfndyVSFhfWwO5b7d0j92YJ06obEaHsJZAa3MI0sYvc=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
