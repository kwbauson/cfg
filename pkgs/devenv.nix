scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-09";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "507bdcad35253545d43a1fc0898da6ecebb6b52a";
    hash = "sha256-Ur44RgRVhYRDbTYHmzBquRC5KcvEuk0zKd6UJ2nHHRU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
