scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ac7d7f707d905874605b51fbf177ab617dd13f20";
    hash = "sha256-nrheCsh45MmBmpsBWrxGa+6+CpjgyFyj42er3CLkk7E=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
