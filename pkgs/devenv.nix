scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-02";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "ae9100ae735baf5b0c491eabf76c6a9ec0a79757";
    hash = "sha256-yphM0TqJM3ci2R9W4E37w64B9XBLHgD4D1IeduOVsmo=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
