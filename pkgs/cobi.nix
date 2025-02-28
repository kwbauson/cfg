scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1596170814eb053860bf67e3fe7ffe0f03ad6b06";
    hash = "sha256-6gtiJoaqmYoDlYaqadSjAfheq+G4FFHAcBGI3QlbRQw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
