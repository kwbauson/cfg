scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "fddbb648a0248c714d2d3bed2a8d7651f8f4e88f";
    hash = "sha256-rjVMSYt8qk6keC9/osr+IO6WFIB8c47bogeOyVCQKpw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
