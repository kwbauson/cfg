scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1cb1eae5b6fe978e2715ea97cde45f1cdb21d66a";
    hash = "sha256-oXko341tQRhiZ/PRRn6DMzUdSH+W/zA/NRqxCTPlxCs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
