scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b8dac09033e9d127c1d473070afadca944b3f773";
    hash = "sha256-zERmQQow3YaRHZM3CvdDWInR7WNIgLp3EJCaHz+xqkw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
