scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "95cdfac33c23402c7cde2ea87fa26cf744a51c89";
    hash = "sha256-L+4LGEapK/grY8o4ufwtQDne41o51+eEBt7E1vJuTsQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
