scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "aa9469024b4de08800d469267c86da2f04c01fbe";
    hash = "sha256-U4ryYexBWS2NL2B6yI8kC2Y8od0cSsf1RKLwT1F4dqM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
