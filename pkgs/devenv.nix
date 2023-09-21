scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-20";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "d3b37c5d6fce8919b9a86c4a3bcacd2d0534341a";
    hash = "sha256-4C+HSXd69qQe12m8Pc6PgLmJGDKURcqkhVdwRu0xrBw=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
