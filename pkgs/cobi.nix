scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b749cb30c0b16b2b6bc2f9af7c0fdd51adc6678b";
    hash = "sha256-mrkBfddXLz+UNyjMhot61WO4hZhDPsB1Ku5gGe9QuXE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
