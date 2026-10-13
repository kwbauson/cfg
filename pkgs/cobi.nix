scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0702c531cbc25115d49faa982173eb1486c3a3b0";
    hash = "sha256-u67Fe797N5QAaE23r+PFPQBztfPNTHzWgN7qi3VxTrw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
