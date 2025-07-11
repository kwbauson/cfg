scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2622c289c28dbbd48f3efcca3baf2d6ef773aedb";
    hash = "sha256-qnSeAT38TQh0IMGSuZYUnbhWguL/zSJ+/wUMQ87XVn0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
