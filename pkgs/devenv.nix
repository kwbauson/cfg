scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-25";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "42a26aa1b2265cf505df056e040e2b1ef8073b76";
    hash = "sha256-+0lqQZmbzdglPh8JoMAZzP1XXanhBg9BcbjVXnwEC5E=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
