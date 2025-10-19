scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "edf053d7953077633a2e2a422a1f8db8be4ceddd";
    hash = "sha256-IYTx4GO1PICB/yUjlEnxxEflsbs4f+0FITHY1ZA+YYg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
