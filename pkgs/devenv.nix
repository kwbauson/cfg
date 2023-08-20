scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-19";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "49ebb9b0a85949f364bacf0088c4142ed451f59e";
    hash = "sha256-0hzA1DzbBfy6Yw4mb0FovRcP1+64AIRKGMSvaQiMctc=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
