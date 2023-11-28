scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-27";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "263efe1290b8481cd6d5d814b4655ce332b7f8b1";
    hash = "sha256-Xgl3mNDpW6MNCmtmP5R6FqEe6B/zI/kCSTgHlXzDyyE=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
