scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-26";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "05240861ef3ae1bbe65b1acc88e2fad7dd24a84b";
    hash = "sha256-8x5DkOaejES6C2JYX2A3riebbJHGFHBmJ+LwxXUIIVw=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
