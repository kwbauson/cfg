scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-06";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "81e7928df0903723af66cca346e6602d029ca610";
    hash = "sha256-YtGw46Y1oevjU0m295UNhq0T81gfq/z7xXbLsRyNaIE=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
