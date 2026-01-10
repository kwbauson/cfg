scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "49ebcb71053edf72ba38c88c8b2acb6a28b28fc5";
    hash = "sha256-2bAsgjdCKWuSLS9GiMYl1sXQKhOnRK7Z493X9jwO0C8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
