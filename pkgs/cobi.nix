scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "576d00bb6fbffc4f80d49010ba808cb3bbfca891";
    hash = "sha256-smxzJ/pGWztqpvYN/5ypaxexBOnnzD2RgtQfIUTxn3Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
