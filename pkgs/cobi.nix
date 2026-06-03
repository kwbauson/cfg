scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "709940e4de584b8d67948c432951ee2faac8b032";
    hash = "sha256-7sc+eP8HPvsGekqxBXhQ4Gz6V2RxE5xfnu+xF1pFiNU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
