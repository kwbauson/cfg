scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "05d5653a184f69544ac9a0f4a93f20b067222851";
    hash = "sha256-OsFTGljzGhb5qdIWADE6+rZld3c+q+B8mpVRWnU5kYc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
