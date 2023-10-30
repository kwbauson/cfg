scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-10-25";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "86f476f7edb86159fd20764489ab4e4df6edb4b6";
    hash = "sha256-n+SbyNQRhUcaZoU00d+7wi17HJpw/kAUrXOL4zRcqE8=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
