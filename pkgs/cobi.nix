scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7117d74ee91ee8e076b743db48f6034cd589b9bc";
    hash = "sha256-jeTC5KDRrxcXubTzErbul9tiEWImcWvA9ns0/k0Ty0M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
